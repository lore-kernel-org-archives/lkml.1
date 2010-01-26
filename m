Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871Ab0AZKjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab0AZKjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339Ab0AZKjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:39:11 -0500
Received: from relay02-haj2.antispameurope.com ([83.246.65.52]:36538 "EHLO
	relay02-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab0AZKjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:39:10 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 05:39:09 EST
Message-ID: <4B5EC50D.8060309@iis.fraunhofer.de>
Date: Tue, 26 Jan 2010 11:33:49 +0100
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       "Frysinger, Michael" <Michael.Frysinger@analog.com>,
       "Getz, Robin" <Robin.Getz@analog.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [RFC] Staging:IIO: New ABI
References: <4B571DA4.6070603@cam.ac.uk> <20100120153748.GA29401@kroah.com> <4B573501.9090001@jic23.retrosnub.co.uk> <20100122204718.GA15759@kroah.com> <20100123001414.GB14538@core.coreip.homeip.net> <20100123003112.GA7836@kroah.com> <20100126093422.GA3480@core.coreip.homeip.net> <8A42379416420646B9BFAC9682273B6D0F1DB670@limkexm3.ad.analog.com> <20100126101135.GA3630@core.coreip.homeip.net> <8A42379416420646B9BFAC9682273B6D0F1DB6AE@limkexm3.ad.analog.com>
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0F1DB6AE@limkexm3.ad.analog.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080507020609090806050202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080507020609090806050202
Content-Type: multipart/mixed;
 boundary="------------050006090309040206010009"

This is a multi-part message in MIME format.
--------------050006090309040206010009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 26.01.2010 11:25, schrieb Hennerich, Michael:
>> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>> On Tue, Jan 26, 2010 at 09:55:45AM +0000, Hennerich, Michael wrote:
>>>
>>>
>>>> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>>>>
>>>> On Fri, Jan 22, 2010 at 04:31:12PM -0800, Greg KH wrote:
>>>>> On Fri, Jan 22, 2010 at 04:14:15PM -0800, Dmitry Torokhov wrote:
>>>>>> On Fri, Jan 22, 2010 at 12:47:18PM -0800, Greg KH wrote:
>>>>>>> On Wed, Jan 20, 2010 at 04:53:21PM +0000, Jonathan Cameron
> wrote:
>>>>>>>> I am not aware of these. Could you direct me to the current
> api? Also note that these
>>>>>>>> aren't the actual alarms, merely a means of enabling the
> relevant event on the related
>>>>>>>> event character device.
>>>>>>>
>>>>>>> Hm, I thought we had an accelerator interface somewhere...
>>>>>>>
>>>>>>
>>>>>> Nope. And I am also interested in this since I am sittign on a
> bunch of
>>>>>> accelerometers, magnetometers, etc drivers that are trying to
> plug into
>>>>>> input sysbsystem and quite unsure what to do with them.
>>>>>>
>>>>>> It was OK whch HDAPS and friends when they were using input for
>>>>>> secondary, toyish purposes, but these new drivers trying to use
> input
>>>>>> devnts as primary API and I am unsure if it is the best
> solution.
>>>>>> Accelerometer might be used as an input device but not always an
> input
>>>>>> device.
>>>>>
>>>>> Yeah, I see it using a joystick interface, which might be
> acceptable for
>>>>> "toy" devices like you say.
>>>>>
>>>>> But for "real" ones, we should do something else.
>>>>>
>>>>> Maybe, for devices that are going to be used by x.org, like the
> "toy"
>>>>> ones, we stick with the current input interface, but for others,
> we use
>>>>> a "real" interface, probably through hwmon, so that users can get
> the
>>>>> real data out in a consistant manner.
>>>>>
>>>>
>>>> I'd rather have all of them use real interface and then have a
> bridge
>>>> to input module to enable toyish mode (unless the device in question=

>>>> is really truly an input device).
>>>>
>>>> --
>>>> Dmitry
>>>
>>
>>> I really don't see that hwmon provides facilities like input/evdev
>>> does.  Queuing of events with time stamping and multiple reader
>>> support.
>>
>> I understand that using evdev might be very convenient but I still
>> believe that input should be used for human interfaces, not for generi=
c
>> data acquisition. The idea is that userpsace consumers should be able
> to
>> query device's capabilities and based on those capabilities be able to=

>> classify and properly handle the device. Now it all breaks when we get=

>> random hardware using EV_ABS/ABS_* for delivering some datastream that=

>> has nothing to do with coordinates.
>
> Acceleration in X,Y,Z translates pretty well in what joysticks deliver.=


But it's not only about accelerometers here. We also have gyros,=20
magnetometers, pressure sensors and generic ADCs.

>>>   The adxl34x accelerometer driver for example is really
>>> intended to be a input device.  Send EV_KEY for x,y,z_TAP detections,=

>>> send EV_KEY for 3D orientation sensing, and EV_ABS for acceleration.
>>> With very minor platform data customization you can use this device
>>> for game controls or GUI interaction.  A few examples include digital=

>>> picture frames, ebook readers, etc.
>>>
>>
>> I see. However, can it be reasonably used for other purposes?
>
> Well - it depends. Some applications for Accelerometers also include:

> Personal navigation devices
(low to mid data rate)

> Hard disk drive (HDD) protection
(only alerts)

> Safety
(probably low data rate)

What we want with IIO is a common high performance interface to these=20
devices. That's why we have ring buffers in the kernel. Possible=20
applications are robotics, precise navigation, data aquisition, etc.

Regards,
--=20
Dipl.-Inf. Manuel Stahl
Fraunhofer-Institut f=FCr Integrierte Schaltungen IIS
- Leistungsoptimierte Systeme -
Nordostpark 93                Telefon  +49 (0)911/58061-6419
90411 N=FCrnberg                Fax      +49 (0)911/58061-6398
http://www.iis.fraunhofer.de  manuel.stahl@iis.fraunhofer.de

--------------050006090309040206010009
Content-Type: text/x-vcard; charset=utf-8;
 name="manuel_stahl.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="manuel_stahl.vcf"

begin:vcard
fn:Manuel Stahl
n:Stahl;Manuel
email;internet:manuel.stahl@iis.fraunhofer.de
tel;work:+49 911 58061-6419
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050006090309040206010009--

--------------ms080507020609090806050202
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIUWDCC
BC4wggMWoAMCAQICAgEMMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNzEyMDUxNTE4NTha
Fw0xOTA2MzAyMzU5NTlaMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEw
HwYDVQQLExhGcmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIg
Um9vdCBDQSAyMDA3MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwz0eyWWNW4g3
9z7BIbZU3rA6VxsaHO6YCHQBWm+13zZXK0RFzvNGE2V2lZhUx6iFFW4SpBfoC+EhpzE9Kd3/
o9ZP0rSJ/WNK2qtT71kFtE/iOyqRmcDLZVeBozCTkA7Jvf0VMjIIpEh8VgXyuzaJ4kjCb0uS
DCVFvq0+1McB7bHIErQwCG6nb396IKe7tOU1gFQsGY/ZS8Adq0P4YRSU+7AdXbeR7GLAkdFe
3acLsy0fZjkYPK4EFOXSfTbZss2nE7DMRZ1WBFFxMzZcL11RE55PSJAOl1pLcNu5edmh1pTI
ktCl+2C/La2ecQAXhsD9SGadFEwFTkzRcUQL0HoPsQIDAQABo4HZMIHWMB8GA1UdIwQYMBaA
FDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUL0VCHjEF
gNVw2PgdV8tbetU9nPcwEgYDVR0TAQH/BAgwBgEB/wIBATBwBgNVHR8EaTBnMGWgY6Bhhl9o
dHRwOi8vcGtpLnRlbGVzZWMuZGUvY2dpLWJpbi9zZXJ2aWNlL2FmX0Rvd25sb2FkQVJMLmNy
bD8tY3JsX2Zvcm1hdD1YXzUwOSYtaXNzdWVyPURUX1JPT1RfQ0FfMjANBgkqhkiG9w0BAQUF
AAOCAQEAGrdMejzl3cJjst6GJU5FYkz08o9fXdfljc4O1/WU4YuTMTanmiPnZ+FSwVoY1pnh
gGQ4D0o1M11meijcOH83cs1SdW4Qjmx9jPcp63fCuRkF1Lc9YbroBRLUUGJT7yJUYvxNAcNe
1A2DdGlR1TyerNukK3xthJbTcU3P1S1xo5LEP1XPmz0jdwdX6cjOHZe2M/uRl2CWD/f23m8l
kBKrGUfVRCOuwZI1KL8qQ14P6gdd0kTQhYLjErxH6iyt+PBBUn02uiKfeqAy70u8+ToHtinG
fThfNVV+OPI/fLPuLW4heF+5E8/v3mWAyCX1Zi1USq3O2S4OMM+AM6eLGXLqQTCCBMYwggOu
oAMCAQICCmEdMxkAAAAAAAMwDQYJKoZIhvcNAQEFBQAwZzELMAkGA1UEBhMCREUxEzARBgNV
BAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4G
A1UEAxMXRnJhdW5ob2ZlciBSb290IENBIDIwMDcwHhcNMDcxMjEyMTQ0OTM1WhcNMTkwNjMw
MjM1OTU5WjBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEhMB8GA1UECxMY
RnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVyIFVzZXIgQ0Eg
MjAwNzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMJ0EFHLddGB8Ss1nVqCOq+S
rs0C/K7I+yB3Dv9oEhWQSadnfGgkX/oOJhplPkqeCQrTh08zEYprVaJLTaVPVhvjx3h5+KML
3lVGZIfajA89TolhLwk+ml29VbqV5nLhNrSwdZy157b6dCu5JffxvpO5wXCn95Z/TLyLdeux
gVHs/MnhczvmBbBRS+Ow9UoKn+PZvyYmUEdOHg8cA5PGFaRP9q88q734VnlI+W4+y7BoN5wt
uqVrqWbbpOQ2sHYo9riv3b+x5WdsMrVieKGApQ/dNvgB5vuuAchRnsANZHgpAiPCzP7/QFYY
qk2undcxEXwPgo72oifB3uQZ3xHOV/cCAwEAAaOCAXIwggFuMBIGA1UdEwEB/wQIMAYBAf8C
AQAwHQYDVR0OBBYEFE8dr4jKbbiqHAn5xdER7Vm0k/oLMA4GA1UdDwEB/wQEAwIBBjAfBgNV
HSMEGDAWgBQvRUIeMQWA1XDY+B1Xy1t61T2c9zB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8v
Y3JsLnBraS5mcmF1bmhvZmVyLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JshjFodHRwOi8vY3Js
LmZyYXVuaG9mZXItcGtpLmRlL2ZoZy1yb290LWNhLTIwMDcuY3JsMIGQBggrBgEFBQcBAQSB
gzCBgDA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQucGtpLmZyYXVuaG9mZXIuZGUvZmhnLXJv
b3QtY2EtMjAwNy5jZXIwPgYIKwYBBQUHMAKGMmh0dHA6Ly9jZXJ0LmZyYXVuaG9mZXItcGtp
LmRlL2ZoZy1yb290LWNhLTIwMDcuY2VyMA0GCSqGSIb3DQEBBQUAA4IBAQAAd2yMM/nuVwQl
ysuIOeZOTKTOwpZLGYZNuERXwpWpEDfsMFUxX/Wetbu1a1qhd+x6SyXY4V1CzcFDOGF3wA7b
yIV/6dyC53I9luZTjy9zjUsjLZucD4jeNja3QEu39sQsYsuE3MTfFFJgr/NeAFMHVkkHGx3l
VXb+F3J3+9xeXHk/wB/yIKd/RIiMMTT4+a+ra2MTCsYAe4kgJ0vz2TXYGN8tujjCgsUUbwfJ
C9wrOiCJMNJM1i7sUVqVKIoswW7h5QpWUNu1E4RAsDEz7depXCYaAIwPprEIkr0dE63zqHhm
M4egS7iGmBfNQohUO6jJOWNcJ9dIxqc0c/4WUHg8MIIFpDCCBIygAwIBAgIKXts1tgAAAACh
VTANBgkqhkiG9w0BAQUFADBnMQswCQYDVQQGEwJERTETMBEGA1UEChMKRnJhdW5ob2ZlcjEh
MB8GA1UECxMYRnJhdW5ob2ZlciBDb3Jwb3JhdGUgUEtJMSAwHgYDVQQDExdGcmF1bmhvZmVy
IFVzZXIgQ0EgMjAwNzAeFw0wOTEyMDkxNDQ3MTlaFw0xNTEyMDgxNDQ3MTlaMFgxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMQwwCgYDVQQLEwNJSVMxDzANBgNVBAsTBlBl
b3BsZTEVMBMGA1UEAxMMTWFudWVsIFN0YWhsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAyc3xmHk19YZAmko+jIM52UsU0keIMlZuSsQvl7HCAGEzifKcfmrR6EX1lYPUKVZJ
BpqMSG3jyA4GW6gR/7cwz0IbnwFPC40KHPODRVIWDIJbZrP6zl+hF+G6/ZTe7ttPahSNhfeq
wkhQZJYQwoxEPoaODFpgQ8St+WRRkgfi3jvjuUIddgWV4NyVAm6m5fmF9a6iv20e+ZSW0As7
brNVf4Xvl5+y58MWniD3hjryz2OsqH1+NrFk8dxPjR4z3tWfty4x4J5af1z25tKX3xnJtx6Q
l61FI1UlSUqR3DHxkmLY7RRCccxtpwOES2YgmBBpJzrxCJ+cYwVJIVHR7I/3qwIDAQABo4IC
XzCCAlswDgYDVR0PAQH/BAQDAgbAMCkGA1UdEQQiMCCBHm1hbnVlbC5zdGFobEBpaXMuZnJh
dW5ob2Zlci5kZTAdBgNVHQ4EFgQUbNwp94oWTogPsGGtBT3dcKtNhXUwHwYDVR0jBBgwFoAU
Tx2viMptuKocCfnF0RHtWbST+gswdQYDVR0fBG4wbDBqoGigZoYxaHR0cDovL2NybC5wa2ku
ZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0yMDA3LmNybIYxaHR0cDovL2NybC5mcmF1bmhv
ZmVyLXBraS5kZS9maGctdXNlci1jYS0yMDA3LmNybDCCAQoGCCsGAQUFBwEBBIH9MIH6MD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5wa2kuZnJhdW5ob2Zlci5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA+BggrBgEFBQcwAoYyaHR0cDovL2NlcnQuZnJhdW5ob2Zlci1wa2kuZGUvZmhn
LXVzZXItY2EtMjAwNy5jZXIwOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3
Lm9jc3AucGtpLmZyYXVuaG9mZXIuZGUvMDsGCCsGAQUFBzABhi9odHRwOi8vZmhnLXVzZXIt
Y2EtMjAwNy5vY3NwLmZyYXVuaG9mZXItcGtpLmRlLzATBgNVHSUEDDAKBggrBgEFBQcDBDBE
BgNVHSAEPTA7MDkGCysGAQQBhgpQAwEBMCowKAYIKwYBBQUHAgEWHGh0dHA6Ly9wa2kuZnJh
dW5ob2Zlci5kZS9jcC8wDQYJKoZIhvcNAQEFBQADggEBACWdlXdPPIhNtjC0aYQgGYQ9+e0N
XHqtaQsxgzZ2D4Rp34VeuZPWkF/YMDXgxB9sarzCO4WcBxz0QWjWiQOtAYzPc+2U3C3Pyw6Y
Mc0yxSpg6R602Hy/O1aNn7XZ50gujpIjuwo0fAFhg8OI63uolkgKAYyoUcTRHc4Z4kwb8bgg
+5a56lKIqBwTweqd2VaNnW0FCfk5bJsaw2j3bHnWkS2D9BWt0U+t+/zCqMYT9E38vTP57kho
vpb44u+8m6Xaaorn3bCK2WzHH5HZp/mVEZ6TZw+mJ+Ltjrcnz+9JAFYZxtpSpZN/k1zRM0P6
6CKxV9JfFqwQJnso0LtpcfLFGuMwggWwMIIEmKADAgECAgpe2zMWAAAAAKFUMA0GCSqGSIb3
DQEBBQUAMGcxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhG
cmF1bmhvZmVyIENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAy
MDA3MB4XDTA5MTIwOTE0NDcxOVoXDTE1MTIwODE0NDcxOVowWDELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxDDAKBgNVBAsTA0lJUzEPMA0GA1UECxMGUGVvcGxlMRUwEwYD
VQQDEwxNYW51ZWwgU3RhaGwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC18idY
1AthSSVhkq1AFUnVfm5pzin5dEuixfJs+PaEQah9OWHYqSCxvXYL/58MtfpCsMl8HpIUsnuh
O4GPDjdxawgLSItU/LCF5/cmdc6swyi2efJC5QviHJ/aB/MbD3TKl9aGQXE0K85/iS4KQT2c
GM8uvWhF3yNNJIuauJ8BMX55vyelXT1rsldiGsBwKQ2PRcoM24jdtw/4DigsImSAkV6rxgg7
CeV92wE1trfx7OOoK9PPgAE9D95oiZz25f2MH7NnD4Wzo+73chdoQnhPZHNBojcxdyg+Rf3O
PCuKfXLYdTgEzEFGNFIwojaKoJ2ws1t2z3O62h7Tye0EMBtTAgMBAAGjggJrMIICZzAOBgNV
HQ8BAf8EBAMCBDAwKQYDVR0RBCIwIIEebWFudWVsLnN0YWhsQGlpcy5mcmF1bmhvZmVyLmRl
MB0GA1UdDgQWBBR3QN2wMBSsk+rxgVGtX5Plvb9tNzAfBgNVHSMEGDAWgBRPHa+Iym24qhwJ
+cXREe1ZtJP6CzB1BgNVHR8EbjBsMGqgaKBmhjFodHRwOi8vY3JsLnBraS5mcmF1bmhvZmVy
LmRlL2ZoZy11c2VyLWNhLTIwMDcuY3JshjFodHRwOi8vY3JsLmZyYXVuaG9mZXItcGtpLmRl
L2ZoZy11c2VyLWNhLTIwMDcuY3JsMIIBCgYIKwYBBQUHAQEEgf0wgfowPgYIKwYBBQUHMAKG
Mmh0dHA6Ly9jZXJ0LnBraS5mcmF1bmhvZmVyLmRlL2ZoZy11c2VyLWNhLTIwMDcuY2VyMD4G
CCsGAQUFBzAChjJodHRwOi8vY2VydC5mcmF1bmhvZmVyLXBraS5kZS9maGctdXNlci1jYS0y
MDA3LmNlcjA7BggrBgEFBQcwAYYvaHR0cDovL2ZoZy11c2VyLWNhLTIwMDcub2NzcC5wa2ku
ZnJhdW5ob2Zlci5kZS8wOwYIKwYBBQUHMAGGL2h0dHA6Ly9maGctdXNlci1jYS0yMDA3Lm9j
c3AuZnJhdW5ob2Zlci1wa2kuZGUvMB8GA1UdJQQYMBYGCisGAQQBgjcKAwQGCCsGAQUFBwME
MEQGA1UdIAQ9MDswOQYLKwYBBAGGClADAQEwKjAoBggrBgEFBQcCARYcaHR0cDovL3BraS5m
cmF1bmhvZmVyLmRlL2NwLzANBgkqhkiG9w0BAQUFAAOCAQEAIny6T0ZtZyrpF4dLpcM6G07I
HDC4cdGFLqfnqRLfMLwgdgxACPkYB8VbApcGKiSxcXaZEaz8CLLMrdwXkta1o+ZA6dz90Y1T
dYlvHvdsuhGeIkNwlJoGwlf4Ts4+7pi2d7sbYX3GFSzD3KcBn6DJp71pl4+MEcvkwVVaBKCw
+ohHssiRmG40fYAmdxBqPmjGyer4PftJdkvZQqmhqVDFp1NTJU9k/CQaIB24iSnuXfjHi1+z
Lz4flTgIGuN6lNAKGGt51kBl+WGy8olUDuyMwFAP7f1WIK4OWKWK0SbmMeDZtdN/aEpRRQ6l
0QATNFeFf1cK8auS+lRgG7lj74w/KzGCA24wggNqAgEBMHUwZzELMAkGA1UEBhMCREUxEzAR
BgNVBAoTCkZyYXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEg
MB4GA1UEAxMXRnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bNbYAAAAAoVUwCQYFKw4DAhoF
AKCCAc4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTAwMTI2
MTAzMzQ5WjAjBgkqhkiG9w0BCQQxFgQUp74pOl7T22qkt4OBPKodr4Bn2HMwXwYJKoZIhvcN
AQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGEBgkrBgEEAYI3EAQxdzB1MGcx
CzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpGcmF1bmhvZmVyMSEwHwYDVQQLExhGcmF1bmhvZmVy
IENvcnBvcmF0ZSBQS0kxIDAeBgNVBAMTF0ZyYXVuaG9mZXIgVXNlciBDQSAyMDA3Agpe2zMW
AAAAAKFUMIGGBgsqhkiG9w0BCRACCzF3oHUwZzELMAkGA1UEBhMCREUxEzARBgNVBAoTCkZy
YXVuaG9mZXIxITAfBgNVBAsTGEZyYXVuaG9mZXIgQ29ycG9yYXRlIFBLSTEgMB4GA1UEAxMX
RnJhdW5ob2ZlciBVc2VyIENBIDIwMDcCCl7bMxYAAAAAoVQwDQYJKoZIhvcNAQEBBQAEggEA
LqXIb4CmKL7etRwAtw/WOppNucQ090LjDStrNfpuu3NmRL4ap8JwD79AytegWI/WGIQPRydU
SSONhaAE2bhfgdpsx/Mxgy4dH2xhlIojdSDqu9XV3tB//98ewiPHoR5oE9eiYxt7Kg3UEtqo
ZuYYg5xYr0Oz6OrH2uXGIzHQDVU82Qtv5DT4PfodrYQxfVhmll/wIsqYfXAN98FTlGsa97GU
wVZtXeLLky4HQdtUYvofWG05FsCPPhPQk0/a//qOy0iuVRxQ/NhsUQmy/C7Lz8vC9i4x8LFb
3Rc+8QZoya8GJwJakt4BQwd8yj4fmrWHCCpUr8OVp1yyTNRFL7iAUQAAAAAAAA==
--------------ms080507020609090806050202--
