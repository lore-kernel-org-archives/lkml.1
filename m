Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab0CJRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:37:38 -0500
Received: from mamba.crocodile.org ([216.218.215.112]:37068 "EHLO
	periplum.crocodile.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932149Ab0CJRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:37:36 -0500
Subject: Re: [PATCH 1/1] integer overflow issue in 'appletouch' driver
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: multipart/signed; boundary=Apple-Mail-25-25148576; protocol="application/pkcs7-signature"; micalg=sha1
From: Vadim Zaliva <lord@crocodile.org>
In-Reply-To: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
Date: Wed, 10 Mar 2010 09:37:16 -0800
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org
Message-Id: <2A955EB9-1686-4C7C-B2D0-17C770A6D2D7@crocodile.org>
References: <E64899AA-23A5-49D7-8C91-B94A095290E0@crocodile.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-25-25148576
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> Just need your Signed-off-by please.


Here it is:

Signed-off-by: Vadim Zaliva <lord@crocodile.org>

(including original patch to put it in context. Sorry if it seems like =
over-quoting)

Sincerely,
Vadim Zaliva

On Mar 5, 2010, at 11:47 , Vadim Zaliva wrote:

> This small patch is fixing an integer overflow issue in 'appletouch' =
driver.
>=20
> In particular, reading data from Geyser 2 touchpads used on post Oct
> 2005 Apple PowerBooks the driver was casting X and Y coordinates
> values to 'signed char'. Testing on one of such PowerBooks I have
> noticed that touchpad always generates positive values, but some of
> them are greater that 127, and thus, when cast to 'signed char' being
> interpreted as a negative.
>=20
> Such bigger values have been observed infrequently, closer to the
> edges of a touchpad, so the problem was not very visible.=20
> Nevertheless, the patch would potentially improve touchpad
> driver accuracy.
>=20
>=20
> diff -uNr linux-source-2.6.31.orig/drivers/input/mouse/appletouch.c =
linux-source-2.6.31/drivers/input/mouse/appletouch.c
> --- linux-source-2.6.31.orig/drivers/input/mouse/appletouch.c	=
2009-09-09 15:13:59.000000000 -0700
> +++ linux-source-2.6.31/drivers/input/mouse/appletouch.c	=
2010-03-05 11:05:11.921394055 -0800
> @@ -205,8 +205,8 @@
> 	bool			overflow_warned;
> 	int			x_old;		/* last reported x/y, */
> 	int			y_old;		/* used for smoothing */
> -	signed char		xy_cur[ATP_XSENSORS + ATP_YSENSORS];
> -	signed char		xy_old[ATP_XSENSORS + ATP_YSENSORS];
> +	u8		    xy_cur[ATP_XSENSORS + ATP_YSENSORS];
> +	u8		    xy_old[ATP_XSENSORS + ATP_YSENSORS];
> 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
> 	int			idlecount;	/* number of empty =
packets */
> 	struct work_struct	work;
> @@ -531,7 +531,7 @@
>=20
> 	for (i =3D 0; i < ATP_XSENSORS + ATP_YSENSORS; i++) {
> 		/* accumulate the change */
> -		signed char change =3D dev->xy_old[i] - dev->xy_cur[i];
> +		int change =3D dev->xy_old[i] - dev->xy_cur[i];
> 		dev->xy_acc[i] -=3D change;
>=20
> 		/* prevent down drifting */
>=20
>=20


--
"Hated by fools, and fools to hate, be this my motto and my fate"
(Jonathan Swift)







--Apple-Mail-25-25148576
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJJzCCAvUw
ggJeoAMCAQICECB7OlRjd+hd7z4JgjHvadQwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDMyMjAxMzM1MloXDTEwMDMyMjAxMzM1
MlowWzEPMA0GA1UEBBMGWmFsaXZhMQ4wDAYDVQQqEwVWYWRpbTEVMBMGA1UEAxMMVmFkaW0gWmFs
aXZhMSEwHwYJKoZIhvcNAQkBFhJsb3JkQGNyb2NvZGlsZS5vcmcwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQCXfiI9AGgXlpbIeEBxrej5GhvuVcHfhErck7P580iCcs3Vvm5RZ3s0kTKG
IW2e0yptAHHA359Ii4cZkk3WD4em+rglh2m7s1fSaL8ydEIImLYgvOun5CecwDJQNqky5xMDUGeo
ckR4tJIjwjfvIwa0ghU3kRUrKOYX8kES+p6ayEvG3r8sz9WRP49XsDCjdd5kSqXbGMwP+3ZSQqhL
x9q0sTT3UJyofi3LJktbz8cJZvwfn0T1f0HKBCx2uRlrY4vy76XggzMOHnsVtsMl7NtLg35wRVjE
JGiM7+xUogbW3zcVr/51BuD/1mpgcRFrOQ76uMHAWQMoOYnmA+OsGUqlAgMBAAGjLzAtMB0GA1Ud
EQQWMBSBEmxvcmRAY3JvY29kaWxlLm9yZzAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GB
AIc7GqDI2x/4wz47B2Rnf6WkKsymelMdjARm8PNbScUpuxwrERdJYWDr2nt5l8pWA8wqF+rhTlL6
5W4KEqxuOVHbLwBVcj7cz757LyZ7z5B+PmF98fYFe2f5K5j5C1tzK/GjgLoA3RpbRFxonC7kDT5L
W2oLU2Cw2NPjYgnZGneEMIIGKjCCBRKgAwIBAgIQAgirQsxAkWAE0T8watDxWTANBgkqhkiG9w0B
AQUFADCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0
eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVz
ZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9u
IGFuZCBFbWFpbDAeFw0xMDAxMjkwMDAwMDBaFw0xMTAxMjkyMzU5NTlaMIHaMTUwMwYDVQQLEyxD
b21vZG8gVHJ1c3QgTmV0d29yayAtIFBFUlNPTkEgTk9UIFZBTElEQVRFRDFGMEQGA1UECxM9VGVy
bXMgYW5kIENvbmRpdGlvbnMgb2YgdXNlOiBodHRwOi8vd3d3LmNvbW9kby5uZXQvcmVwb3NpdG9y
eTEfMB0GA1UECxMWKGMpMjAwMyBDb21vZG8gTGltaXRlZDEVMBMGA1UEAxMMVmFkaW0gWmFsaXZh
MSEwHwYJKoZIhvcNAQkBFhJsb3JkQGNyb2NvZGlsZS5vcmcwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDrTYIpuA0jBtZI1rxaPLm7SpwinDADnS0MXYUsyo3W9+1+W9VM1JYE0rDBF0Fa
JfWcIVSxkBB01Rwi08Drav84yShtd9supINDWMMlGtv6a18Dfe9IpyT58/laWS76CW0YAuLARBQM
sXNhCzhiyJadtjxP4azfSTuH6nRp7Rou+kc7n/k4nAlGf5kNdz3VpdAmc+t3tJdXAoiaBzdU78EA
j4sy+SUWxJiE0rBjPmHTKHLhvkeUMUt+L9rE0Sp0EyhZCGcruhF+jUGyTUF+A+o4IoXcnQQW05ii
r01dX4FoVhDylSKKvj0mMsaGTXsSWjA/R8kngAK89oLzgJQb8R5tAgMBAAGjggIUMIICEDAfBgNV
HSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUM0p5uwPrs7TKgNJ+Vxt4xGvg
gq4wDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysG
AQQBsjEBAwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATAr
MCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzCBpQYDVR0fBIGdMIGa
MEygSqBIhkZodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9VVE4tVVNFUkZpcnN0LUNsaWVudEF1dGhl
bnRpY2F0aW9uYW5kRW1haWwuY3JsMEqgSKBGhkRodHRwOi8vY3JsLmNvbW9kby5uZXQvVVROLVVT
RVJGaXJzdC1DbGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBsBggrBgEFBQcBAQRgMF4w
NgYIKwYBBQUHMAKGKmh0dHA6Ly9jcnQuY29tb2RvY2EuY29tL1VUTkFBQUNsaWVudENBLmNydDAk
BggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMB0GA1UdEQQWMBSBEmxvcmRAY3Jv
Y29kaWxlLm9yZzANBgkqhkiG9w0BAQUFAAOCAQEAiMrZhtw5SxpodA9FZkYX0e6MIqZtlFILiQqc
vT8gmG7I5u8PJRihOAk+GWy14fKlaGskJHgYhU0zXaYwVdJey9TB/WCGxrWwPWe+/O5vkUyaj0c8
uaZ69JYGyuOln1fHRpeSaX9dAyKCqaJYUM6NIZ9gB1pkU54SpE2e5bj5WoNlihg8LXKFk1lWQajC
3m9yeRIi0z3gHJzCOB07tjkcvs+Sz4muFPzDwY9CfmoUTpeL4SPb8i9j9VQ4RxkNRmSFlrbHpEvE
58rJdcTjHft61CfpffqbLMEdHtWL/TTo+ETauVTChLqPaSc2p1Wnqha9ph+dVQGZy3ST4jrwrqaI
PDGCA14wggNaAgEBMIHDMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNh
bHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0
dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0
aGVudGljYXRpb24gYW5kIEVtYWlsAhACCKtCzECRYATRPzBq0PFZMAkGBSsOAwIaBQCgggFvMBgG
CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEwMDMxMDE3MzcyMVowIwYJ
KoZIhvcNAQkEMRYEFFT57TUKIQ0RnmH6rTF7KWTJFXbIMIGFBgkrBgEEAYI3EAQxeDB2MGIxCzAJ
BgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQIHs6VGN36F3vPgmCMe9p1DCB
hwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3Vs
dGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWlu
ZyBDQQIQIHs6VGN36F3vPgmCMe9p1DANBgkqhkiG9w0BAQEFAASCAQB6ghct1MG6vl0ueUels2Aw
eGxDJY5kKdvmBHC/MiDMP4OVUlq89ZHZReBIlb/7YtMt3AGbRRI764rV4UrGZFhX+Ee3UGACmZEy
MTnk4lBt/LLgQkhpeiacEzPX8eIfcSwOTG4VO5EM0Px5c+VKTiMe6gokKts4KKrVGyTq7Jm+XdKL
WDcY1V+YWwtX089Yw6s1JgAOnHe2E4dddQT6ZZIlggCqXOUT56PWzQ9nLOuoczu41QX1Dcci5AyD
M93+QmpsoGdoTNzMbuSGhcp/sJFTqGwriIKFk3xBDJFrxIcafuu5Y7kCiohCcQ6k2BB8sEVxvXoy
XnpUaSmSOj6w7LS+AAAAAAAA

--Apple-Mail-25-25148576--
