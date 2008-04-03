Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYDCCcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYDCCcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbYDCCcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:32:00 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33967 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbYDCCb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:31:59 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>,
       <m-takahashi@ex.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>	 <008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com> <6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com>
In-Reply-To: <6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com>
Subject: RE: [RFC][patch 3/11][CFQ-cgroup] Introduce cgroup subsystem
Date: Thu, 3 Apr 2008 11:31:43 +0900
Message-Id: <003001c89532$dae5dd20$90b19760$@jp.nec.com>
X-Mailer: Microsoft Office Outlook 12.0
MIME-Version: 1.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwAGPpOA
Content-Language: ja
Content-Type: multipart/signed;
	protocol="application/x-pkcs7-signature";
	micalg=SHA1;
	boundary="----=_NextPart_000_002C_01C8957E.4A9907A0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1jM MIME `.L}`p[g bZ[WE7B

------=_NextPart_000_002C_01C8957E.4A9907A0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thank you for reply.

> >  +
> >  +static struct cgroup_subsys_state *
> >  +cfq_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >  +{
> >  +       struct cfq_cgroup *cfqc;
> >  +
> >  +       if (!capable(CAP_SYS_ADMIN))
> >  +               return ERR_PTR(-EPERM);
> >  +
> >  +       if (!cgroup_is_descendant(cont))
> >  +               return ERR_PTR(-EPERM);
> 
> What are these checks for? Cgroups already provides filesystem
> permissions to control directory creation, and the "descendant" check
> looks like it may have been cut/pasted from the nsproxy subsystem.
> 

This code was referred one of io-throttle.
Is it not necessary these checks?
IF not necessary, remove this code.

> 
> >   /* */
> >  +
> >  +#ifdef CONFIG_CGROUP_CFQ
> >  +SUBSYS(cfq_cgroup)
> >  +#endif
> >  +
> >  +/* */
> 
> To fit with the convention for other subsystems, simply "cfq" would be
> a better name than "cfq_cgroup". (Clearly it's a cgroup subsystem from
> context).
> 

Ok, I change name.
I hesitated whether using "_cgroup".
The cpuset and the cpuacct does not use it,
but cpu and memory uses it(cpu_cgroup and mem_cgroup).
In this patchset, I select the latter case.


> Is this subsystem meant to allow you to control any device that uses
> CFQ, or is it specific to disks? It would be nice to be able to allow
> different groups have different guarantees on different disks.
>

I want to allow to control any devices. (Now, any devices using CFQ)
However, I think the main target of above device is disk devices.

I think so that a different groups have different guarantees on different disks.
And, It would be more better to be able to allow different hierarchies for different disks.
 
Now, I consider two solutions.

One is that a new resource manager(subsystem) is created when new device is plugged.
But, The current cgroup framework would not be resisted dynamically.

The another is that a new file entry is resisted when new device is plugged.
But, when a new cgroup is created, there are only information that request_queue and cgroup structure.
So, I seem that device name cannot be referred.
Namely, a name of entry cannot be defined.
And, this means cannot have different hierarchies.

I try to this mechanism in future.


I missed.
This patchset is not all.
There is not a patch for adding the "ioprio" entry.
I resend this patchset after fixing name and checking.


Thanks,
Satoshi UCHIDA

------=_NextPart_000_002C_01C8957E.4A9907A0
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOlTCCAwMw
ggJsAhEAuS9gzIifoXpGCbhbcGyKrzANBgkqhkiG9w0BAQUFADCBwTELMAkGA1UEBhMCVVMxFzAV
BgNVBAoTDlZlcmlTaWduLCBJbmMuMTwwOgYDVQQLEzNDbGFzcyAyIFB1YmxpYyBQcmltYXJ5IENl
cnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzIxOjA4BgNVBAsTMShjKSAxOTk4IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5l
dHdvcmswHhcNOTgwNTE4MDAwMDAwWhcNMjgwODAxMjM1OTU5WjCBwTELMAkGA1UEBhMCVVMxFzAV
BgNVBAoTDlZlcmlTaWduLCBJbmMuMTwwOgYDVQQLEzNDbGFzcyAyIFB1YmxpYyBQcmltYXJ5IENl
cnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzIxOjA4BgNVBAsTMShjKSAxOTk4IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5l
dHdvcmswgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKeIASF0LOcaA/CY4Zc8DyEI8Zzbl+ma
/MIEBhO+X1LIzB4sElYsuAFpLMyZH62wlq55BPITOcF7mLoILOjChBMsqmnpCfTHqQKkQsIjT0rY
8A6i+zFsyeZvmScH9eb0THiebetGhvq5hslU8rLEr9RGHFrJFTD/DWz1LQ5tzn93AgMBAAEwDQYJ
KoZIhvcNAQEFBQADgYEAci75f9HxcfvEnvbFXlGKQJi4aPibHIPY4p29/+2h5mbqLwn0ytfqpSuV
9iRghk1ELoOlxC2g0654aW9y2myuCPBjkjfmu8QwF613zEk1qs/Yj9G+txiWR3NqVCI0ZC22FptZ
W7RRWTqzCxT0Et9noPStMmResUZyJ4wSe8VEtK4wggMoMIICkaADAgECAhA+qlTerNRoazsbOUVJ
TBomMA0GCSqGSIb3DQEBBQUAMIHBMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIElu
Yy4xPDA6BgNVBAsTM0NsYXNzIDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkgLSBHMjE6MDgGA1UECxMxKGMpIDE5OTggVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9yaXpl
ZCB1c2Ugb25seTEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazAeFw0wNTEwMDQwMDAw
MDBaFw0xNTEwMDMyMzU5NTlaMGgxHDAaBgNVBAoTE1ZlcmlTaWduIEphcGFuIEsuSy4xHzAdBgNV
BAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxJzAlBgNVBAMTHlZlcmlTaWduIEphcGFuIENsYXNz
IDIgQ0EgLSBHMjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA5JsvD0+KUQS2rzJlTe4hmbmF
LWy9FpXMdbmd0UL4Lgjcx6XJ3eFBD/ikQDECGQy2s0LVLeJIqTXIl5exip9Gfuts2flFuYwQH+nz
6bYyHMeVa3tV1i6unJt5LvvjWaloa45XFRPDRKoOce7PXeSo7w10krfxv3SuL4zXWZYG5gkCAwEA
AaN5MHcwDAYDVR0TBAUwAwEB/zA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnZlcmlzaWdu
LmNvbS9wY2EyLWcyLmNybDALBgNVHQ8EBAMCAQYwJAYDVR0RBB0wG6QZMBcxFTATBgNVBAMTDEFm
ZlNDQzItMS0yMTANBgkqhkiG9w0BAQUFAAOBgQA9mTgsTNkcwdPj6gStaj5dN++dVdOJ9eTx2JL5
k7UO2JXRo4W4MpDaDlPQLK2PKlD7rwN8u1MMRJqBLGDYS2q90w21EahEqks2vM4wwcngkI2JOo29
Xl3YX1fs9yUJoFQgK/eEsukQUfzqFm0uNS0dB3dTGoL6kfB0m1G3xgQRTzCCBAkwggNyoAMCAQIC
EC3oz0Aci2KA6fbSWP7SPlwwDQYJKoZIhvcNAQEFBQAwaDEcMBoGA1UEChMTVmVyaVNpZ24gSmFw
YW4gSy5LLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazEnMCUGA1UEAxMeVmVyaVNp
Z24gSmFwYW4gQ2xhc3MgMiBDQSAtIEcyMB4XDTA3MTExOTAwMDAwMFoXDTEyMTExODIzNTk1OVow
geYxGDAWBgNVBAoTD05FQyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0
d29yazE9MDsGA1UECxM0VGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvLmpw
L3JwYSAoYykwNzE1MDMGA1UECxMsQ2xhc3MgMiBNYW5hZ2VkIFBLSSBJbmRpdmlkdWFsIFN1YnNj
cmliZXIgQ0ExMzAxBgNVBAMTKk5FQyBHcm91cCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBTTUlN
RSBHMjCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAvfQ0r1UA+dar8d1+/5HcgHtAt8A9gTTG
Cw13bryEGY7R4gI97HtaY4U+DamaLSbrWeUOYfyR8Y8ysWnAY7yck3Krjh9o5kvUllGtwE0X5cqa
zBdsLSDAlGHsWqa+HE6luhPLa3vtev2iBz2l6IfprnxFtSSfhpeGc6bQRSht9qsCAwEAAaOCATMw
ggEvMBIGA1UdEwEB/wQIMAYBAf8CAQAwdAYDVR0gBG0wazBpBgtghkgBhvhFAQcXAjBaMCoGCCsG
AQUFBwIBFh5odHRwczovL3d3dy52ZXJpc2lnbi5jby5qcC9jcHMwLAYIKwYBBQUHAgIwIBoeaHR0
cHM6Ly93d3cudmVyaXNpZ24uY28uanAvcnBhMD4GA1UdHwQ3MDUwM6AxoC+GLWh0dHA6Ly9jcmwu
dmVyaXNpZ24uY28uanAvVlNKX0MyQ0FfRzJfQ1JMLmNybDAOBgNVHQ8BAf8EBAMCAQYwEQYJYIZI
AYb4QgEBBAQDAgEGMCEGA1UdEQQaMBikFjAUMRIwEAYDVQQDEwlDMUMyLTEtNDEwHQYDVR0OBBYE
FPsxd4D2b3RLvmLzv2oQ4Y5LmXuzMA0GCSqGSIb3DQEBBQUAA4GBAFr6givYdv5XMhtJoI5drUY5
xfwRm3x1Cwxz1PtisrgICNgr/L3H/x8cnHeIi+Yoe+xAsxEIJluJ4Cmp36XVoTL1eBPKITGPHANp
Sb/xP1npqhwzRewmYMAjmS//gfmibwgigHXeoi6qe+rExcoURsx85x/C3CE8nj0i6tra5xuXMIIE
UTCCA7qgAwIBAgIQaVBdqYaROOk+QcGWwy/QjDANBgkqhkiG9w0BAQUFADCB5jEYMBYGA1UEChMP
TkVDIENvcnBvcmF0aW9uMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMT0wOwYDVQQL
EzRUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY28uanAvcnBhIChjKTA3MTUw
MwYDVQQLEyxDbGFzcyAyIE1hbmFnZWQgUEtJIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTEzMDEG
A1UEAxMqTkVDIEdyb3VwIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFNNSU1FIEcyMB4XDTA4MDQw
MTAwMDAwMFoXDTEwMDQwMTIzNTk1OVowgeYxGDAWBgNVBAoUD05FQyBDb3Jwb3JhdGlvbjEzMDEG
A1UECxQqTkVDIEdyb3VwIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFNNSU1FIEcyMTUwMwYDVQQL
EyxUZXJtcyBvZiB1c2UgYXQgd3d3LnZlcmlzaWduLmNvLmpwL3JwYSAoYykwNzE3MDUGA1UEAxMu
U2F0b3NoaSBVY2hpZGEgKDA4MDQwMSBzLXVjaGlkYS5hcC5qcC5uZWMuY29tKTElMCMGCSqGSIb3
DQEJARYWcy11Y2hpZGFAYXAuanAubmVjLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA
26zZ9qW9iGpprVmxpneg2gI11mGghEY/qTDjrXjKuGgJwpceMLoKj17QQykEyYkwu1ogfjFgFi1r
NMImsJnV7fQN7tCfL/0TPZ1ix67cNK79Xg2OUzAQpcN8jbBC9XpznS4guQ8Up7yCrzymiW0fL+7I
J36pho16WM+Ej7WKxUUCAwEAAaOB/TCB+jAJBgNVHRMEAjAAMAsGA1UdDwQEAwIFoDByBgNVHR8E
azBpMGegZaBjhmFodHRwOi8vb25zaXRlY3JsLnZlcmlzaWduLmNvLmpwL05FQ0NvcnBvcmF0aW9u
TkVDR3JvdXBDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5U01JTUVHMi9MYXRlc3RDUkwuY3JsMEYGA1Ud
IAQ/MD0wOwYLYIZIAYb4RQEHFwIwLDAqBggrBgEFBQcCARYeaHR0cHM6Ly93d3cudmVyaXNpZ24u
Y28uanAvcnBhMBEGCWCGSAGG+EIBAQQEAwIFIDARBgpghkgBhvhFAQYJBAMBAf8wDQYJKoZIhvcN
AQEFBQADgYEAVaB3JWSywm1ACTPZ9oHlA0MLVccciw8JpXzwwnW63OUOUstPmyOGPYdv3BidJs0H
OLpijTBw7EFQAHfk7qs6gZYUkQ1vmfOyCyA66M8LW4NYWJ24O8lXZEa91r4+K59UgybiuM1wYSxF
M1+qRD0Iuu4YYxStY6qCilwofkRfgL4xggSOMIIEigIBATCB+zCB5jEYMBYGA1UEChMPTkVDIENv
cnBvcmF0aW9uMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMT0wOwYDVQQLEzRUZXJt
cyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY28uanAvcnBhIChjKTA3MTUwMwYDVQQL
EyxDbGFzcyAyIE1hbmFnZWQgUEtJIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTEzMDEGA1UEAxMq
TkVDIEdyb3VwIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFNNSU1FIEcyAhBpUF2phpE46T5BwZbD
L9CMMAkGBSsOAwIaBQCgggLoMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTA4MDQwMzAyMzE0M1owIwYJKoZIhvcNAQkEMRYEFNNFEH70JxAv66bVF/UqIc/94tYBMGcG
CSqGSIb3DQEJDzFaMFgwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMAcGBSsOAwIaMAoGCCqGSIb3DQIFMIIBDAYJKwYBBAGC
NxAEMYH+MIH7MIHmMRgwFgYDVQQKEw9ORUMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlZlcmlTaWdu
IFRydXN0IE5ldHdvcmsxPTA7BgNVBAsTNFRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJp
c2lnbi5jby5qcC9ycGEgKGMpMDcxNTAzBgNVBAsTLENsYXNzIDIgTWFuYWdlZCBQS0kgSW5kaXZp
ZHVhbCBTdWJzY3JpYmVyIENBMTMwMQYDVQQDEypORUMgR3JvdXAgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkgU01JTUUgRzICEGlQXamGkTjpPkHBlsMv0IwwggEOBgsqhkiG9w0BCRACCzGB/qCB+zCB
5jEYMBYGA1UEChMPTkVDIENvcnBvcmF0aW9uMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3
b3JrMT0wOwYDVQQLEzRUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY28uanAv
cnBhIChjKTA3MTUwMwYDVQQLEyxDbGFzcyAyIE1hbmFnZWQgUEtJIEluZGl2aWR1YWwgU3Vic2Ny
aWJlciBDQTEzMDEGA1UEAxMqTkVDIEdyb3VwIENlcnRpZmljYXRpb24gQXV0aG9yaXR5IFNNSU1F
IEcyAhBpUF2phpE46T5BwZbDL9CMMA0GCSqGSIb3DQEBAQUABIGAcLSjOn7lR9ayYj6EhHlUZlt5
NIZnAY3j7rWrR1ZHmK/BGqydg004UTHrKTysonpXEoWj9yi6ynZwpZ0eMWWY0Kha27OeWtN+1VnE
PdpyVQXiX/hbZrUmr1LZQBaFHDKXEi/GuXPFjLkTZhCFBZUzMopA6lLLySOFGekvpUf+2mAAAAAA
AAA=

------=_NextPart_000_002C_01C8957E.4A9907A0--

