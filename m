Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXBKM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXBKM22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 07:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932669AbXBKM22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 07:28:28 -0500
Received: from tag.witbe.net ([81.88.96.48]:43990 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbXBKM21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 07:28:27 -0500
X-Greylist: delayed 3539 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 07:28:26 EST
Reply-To: <rol@witbe.net>
From: "Paul Rolland" <rol@witbe.net>
To: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Cc: <rol@as2917.net>
Subject: 2.6.20/2.6.20-rc7 : ethX renumbered
Date: Sun, 11 Feb 2007 12:28:37 +0100
Organization: Witbe.net
Message-ID: <011001c74dcf$c60c1c80$2101a8c0@donald>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Thread-Index: AcdNz8V86UnRHiI5QmagvVYgeUJj7A==
Content-Type: multipart/signed;
	micalg=SHA1;
	protocol="application/x-pkcs7-signature";
	boundary="----=_NextPart_000_010B_01C74DD8.27427550"
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_010B_01C74DD8.27427550
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

I'm facing something quite strange... When booting one of these kernels
(it's a new machine, I've not been running older kernels), the boot message
says :

ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
sky2 v1.10 addr 0xff8fc000 irq 19 Yukon-EC (0xb6) rev 2
sky2 eth0: addr 00:18:f3:e0:5d:d4
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
sky2 v1.10 addr 0xff7fc000 irq 16 Yukon-EC (0xb6) rev 2
sky2 eth1: addr 00:18:f3:e0:36:fd

So, I'm expecting two interfaces : eth0 and eth1

Unfortunately, at the end of the boot process, I can find eth1 and eth2,
something/somewhat/someone has renumbered them ;

eth1      Link encap:Ethernet  HWaddr 00:18:F3:E0:36:FD  
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
          Interrupt:16 

eth2      Link encap:Ethernet  HWaddr 00:18:F3:E0:5D:D4  
          inet addr:192.168.1.3  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::218:f3ff:fee0:5dd4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:42780 errors:0 dropped:0 overruns:0 frame:0
          TX packets:25519 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:61859841 (58.9 MiB)  TX bytes:2031644 (1.9 MiB)
          Interrupt:19 

This does also occurs when I boot in single user mode, so I did a quick check
at the processes running then, and found udevd, but there is no reference to
ethX in the configuration files, only veth :
 
root@riri:/Kernels/External# cd /etc/udev/
root@riri:/etc/udev# grep -r eth *
rules.d/90-modprobe.rules:ENV{VIO_TYPE}=="network",
RUN+="/sbin/modprobe -Qba ibmveth"
rules.d/90-modprobe.rules:ENV{VIO_TYPE}=="vlan",
RUN+="/sbin/modprobe -Qba iseries_veth"

Is it something expected ? Or is it because Sky2 is still EXPERIMENTAL ?

Regards,
Paul

------=_NextPart_000_010B_01C74DD8.27427550
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKYTCCBKIw
ggOKoAMCAQICEES+DItQACS0EdM2JSVnyYkwDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNVBAYTAlVT
MQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VS
VFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQD
Ey1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwwHhcNOTkwNzA5
MTcyODUwWhcNMTkwNzA5MTczNjU4WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYD
VQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYD
VQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSD
ZJ0uKdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1le
pS/Pytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGo
Lhu21DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0
YqoYymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOBuTCBtjALBgNVHQ8EBAMCAcYw
DwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUiYJnfcSdJnAAS7RQSHzePa4Ebn0wWAYDVR0fBFEw
TzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0
aGVudGljYXRpb25hbmRFbWFpbC5jcmwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMA0G
CSqGSIb3DQEBBQUAA4IBAQCxbWFdphp/fKtK5DD8U28lJMbK7eIxXCsO7u5hVW8EPs853sUbSZTk
6yBMtOaeUC5y2Y31qqOzStpWHGCXgNyCoq1KvYor/wsJtMbXIARF5M2AAbq6K27OqteS/uSv6/Qm
HRYqf2wwlTcvMxKsf93H0RGMUZiy0KOR0K32n56Dkx4dQrhGr2tm8Jt/6uMDAuUCUcGq1TWdckAD
iboxHcUQaFKe36KFxVwIpnjmU0+x6LfTFJ6TpsNk46x+cc28n+kDG8z76awxwa98FXQCmcOyR6bC
MmHXx29IJFEnodWHVfJ7j5g9Fp7udbb40I7y88auKFun8PM2F/zDBdPKA0pUMIIFtzCCBJ+gAwIB
AgIQFr8315BMbmPiG0Ikx7Zr1zANBgkqhkiG9w0BAQUFADCBrjELMAkGA1UEBhMCVVMxCzAJBgNV
BAgTAlVUMRcwFQYDVQQHEw5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBO
ZXR3b3JrMSEwHwYDVQQLExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1V
U0VSRmlyc3QtQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDAeFw0wNjExMDcwMDAwMDBa
Fw0wNzExMDcyMzU5NTlaMIHVMTUwMwYDVQQLEyxDb21vZG8gVHJ1c3QgTmV0d29yayAtIFBFUlNP
TkEgTk9UIFZBTElEQVRFRDFGMEQGA1UECxM9VGVybXMgYW5kIENvbmRpdGlvbnMgb2YgdXNlOiBo
dHRwOi8vd3d3LmNvbW9kby5uZXQvcmVwb3NpdG9yeTEfMB0GA1UECxMWKGMpMjAwMyBDb21vZG8g
TGltaXRlZDEVMBMGA1UEAxMMUGF1bCBSb2xsYW5kMRwwGgYJKoZIhvcNAQkBFg1yb2xAd2l0YmUu
bmV0MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDiOZVqGBTsRhMQJwAzw30Rq3djM3LsMlQQ
lEDLZADATmebnXKQEnAbOzX5hCT5SmCoWGXMNY9LQbIO7UP35D6dhX9v7JGhi7vKYux8ML7vDhfU
9WUWXOEwuoGztwaCmcFgCJ9TeT8VkQzreTboJAMc7QRH1FSICm7KHyht+X9X0wIDAQABo4ICKjCC
AiYwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFHWiupmbJCLb4Ytb
s4FoM0+HEnhWMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsGAQUF
BwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEEAbIx
AQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwgaUGA1Ud
HwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vVVROLVVTRVJGaXJzdC1DbGll
bnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEigRoZEaHR0cDovL2NybC5jb21vZG8ubmV0
L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwgYYGCCsGAQUF
BwEBBHoweDA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vVVROQWRkVHJ1c3RD
bGllbnRDQS5jcnQwOQYIKwYBBQUHMAKGLWh0dHA6Ly9jcnQuY29tb2RvLm5ldC9VVE5BZGRUcnVz
dENsaWVudENBLmNydDAYBgNVHREEETAPgQ1yb2xAd2l0YmUubmV0MA0GCSqGSIb3DQEBBQUAA4IB
AQBGXWZvvagWiNCryeQbnd8sljG8yPxVS7fBVEX/UbXA0RJtsNVs6qgWA2obsdKSxBhdKUjJhsWw
3T6x8phZPOsNRVNxSMGSS4hYXohsnsK+2EQoJ4tL9dg+ef72AD2e87+ni0vju85wTozXvAfMRAp6
csNJx+C9yl043hfPcipcxinKxh5qDs2NS3jqQa+XIr6FzK5UgTt9DiZNcg8iWC5wOJIG8k+J8YVr
HqKgH3Ulugw69axsv1aoKJSnzh6n2dqS5Vdhaa2NeD/6o34dt8wtpxLOGZbkvGusxXmHEKxxD+/B
PQ9upSdOHWqeGYCaGCidUPnuarb7FAbypPMfArk5MYID5DCCA+ACAQEwgcMwga4xCzAJBgNVBAYT
AlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBV
U0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYD
VQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwCEBa/N9eQ
TG5j4htCJMe2a9cwCQYFKw4DAhoFAKCCAnYwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMDcwMjExMTEyODM3WjAjBgkqhkiG9w0BCQQxFgQU+YSVsDPcdUskrJ+Pzjol
LXd7mbMwZwYJKoZIhvcNAQkPMVowWDAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwBwYFKw4DAhowCgYIKoZIhvcNAgUwgdQG
CSsGAQQBgjcQBDGBxjCBwzCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQHEw5T
YWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQLExho
dHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIGFuZCBFbWFpbAIQFr8315BMbmPiG0Ikx7Zr1zCB1gYLKoZIhvcNAQkQAgsx
gcaggcMwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENp
dHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51
c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlv
biBhbmQgRW1haWwCEBa/N9eQTG5j4htCJMe2a9cwDQYJKoZIhvcNAQEBBQAEgYBKWoJZKyJbCEeL
v91XeiqBWqnB67NWO6Jl+/dc5orrMPgbPtaYMqrzWQQjIRHkyJMy+b0zuf/HWZYUgmUikhCRTOyM
C4avhzZZ65g/SQ/9AVO7zCwLpi/3OjaVRVcV+pkV8avVcmWv2z48rRsznNlxkpBvmTFqDQYDXQMM
nuojOQAAAAAAAA==

------=_NextPart_000_010B_01C74DD8.27427550--

