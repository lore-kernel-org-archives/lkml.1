Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbYDCAou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbYDCAou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbYDCAob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:44:31 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:3915 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760487AbYDCAoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=lfhO4moMnVgm9Q+ENCqLr7xTFUif0NiJEV+3iT4Vtr/M5PkVUCSBLRJ6PI5O25XmtsaZElF3+eyJag2IrVfqNK0nxDmzKXjzRZJxLKl9Gn625e0TIplTPwU7BH4xboaHWrr1y0x1JwdmMIjiommVsOSFlPDTmbimEGKFQU+iuxM=
Message-ID: <dd18b0c30804021744m67fe4db4m8aed3897945baaa8@mail.gmail.com>
Date: Thu, 3 Apr 2008 00:44:24 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: suspend
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <47F42259.8030603@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_6979_33351618.1207183464442"
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804021419.06672.rjw@sisk.pl>
	 <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
	 <200804021939.46733.rjw@sisk.pl>
	 <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
	 <47F42259.8030603@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_6979_33351618.1207183464442
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello; attached is kern.log as asked and lspci -nn.
I've noticed some avc's in there. makes me wonder if this is why
wpa_supplicant isnt working after a wakeup
regards;
                Justin P. Mattock

On Thu, Apr 3, 2008 at 12:18 AM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
>  Justin Mattock wrote:
>
> >
> > >  > [ 1233.811794] sd 2:0:1:0: [sda] Starting disk
> > >  > [ 1234.013599] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> > >  > [ 1234.013601] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
> > >  > [ 1234.180232] ata1.00: configured for UDMA/66
> > >  > [ 1222.732011] ata3.01: NODEV after polling detection
> > >  > [ 1222.732016] ata3.01: revalidation failed (errno=-2)
> > >
> >
>
>  I presume this is ata_piix, right?  What's hanging off of ata3.01?  An
> optical drive?
>
>  What happened is that, after resuming, libata reseted the channel and
> issued IDENTIFY[_PACKET] to make sure the device was still there.  The
> device violated the state machine transition in the same way as when there's
> no device attached.  libata paused for a while and retries and the device
> responded correctly at the retry.  Things like this can happen.  The problem
> is that libata resume is currently synchronous and retries like this hold
> the machine back from reaching operational status even when there's no
> reason for resume retrial on optical drive to delay the rest of resume
> process.
>
>  Can you please post full kernel log and the result of 'lspci -nn'?
>
>  --
>  tejun
>



-- 
Justin P. Mattock

------=_Part_6979_33351618.1207183464442
Content-Type: application/octet-stream; name=lspci
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fekluuq31
Content-Disposition: attachment; filename=lspci

MDA6MDAuMCBIb3N0IGJyaWRnZSBbMDYwMF06IEludGVsIENvcnBvcmF0aW9uIE1vYmlsZSA5NDVH
TS9QTS9HTVMsIDk0My85NDBHTUwgYW5kIDk0NUdUIEV4cHJlc3MgTWVtb3J5IENvbnRyb2xsZXIg
SHViIFs4MDg2OjI3YTBdIChyZXYgMDMpCjAwOjAxLjAgUENJIGJyaWRnZSBbMDYwNF06IEludGVs
IENvcnBvcmF0aW9uIE1vYmlsZSA5NDVHTS9QTS9HTVMsIDk0My85NDBHTUwgYW5kIDk0NUdUIEV4
cHJlc3MgUENJIEV4cHJlc3MgUm9vdCBQb3J0IFs4MDg2OjI3YTFdIChyZXYgMDMpCjAwOjA3LjAg
UGVyZm9ybWFuY2UgY291bnRlcnMgWzExMDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiBVbmtub3duIGRl
dmljZSBbODA4NjoyN2EzXSAocmV2IDAzKQowMDoxYi4wIEF1ZGlvIGRldmljZSBbMDQwM106IElu
dGVsIENvcnBvcmF0aW9uIDgyODAxRyAoSUNINyBGYW1pbHkpIEhpZ2ggRGVmaW5pdGlvbiBBdWRp
byBDb250cm9sbGVyIFs4MDg2OjI3ZDhdIChyZXYgMDIpCjAwOjFjLjAgUENJIGJyaWRnZSBbMDYw
NF06IEludGVsIENvcnBvcmF0aW9uIDgyODAxRyAoSUNINyBGYW1pbHkpIFBDSSBFeHByZXNzIFBv
cnQgMSBbODA4NjoyN2QwXSAocmV2IDAyKQowMDoxYy4xIFBDSSBicmlkZ2UgWzA2MDRdOiBJbnRl
bCBDb3Jwb3JhdGlvbiA4MjgwMUcgKElDSDcgRmFtaWx5KSBQQ0kgRXhwcmVzcyBQb3J0IDIgWzgw
ODY6MjdkMl0gKHJldiAwMikKMDA6MWMuMiBQQ0kgYnJpZGdlIFswNjA0XTogSW50ZWwgQ29ycG9y
YXRpb24gODI4MDFHIChJQ0g3IEZhbWlseSkgUENJIEV4cHJlc3MgUG9ydCAzIFs4MDg2OjI3ZDRd
IChyZXYgMDIpCjAwOjFkLjAgVVNCIENvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMUcgKElDSDcgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMxIFs4MDg2OjI3Yzhd
IChyZXYgMDIpCjAwOjFkLjEgVVNCIENvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMUcgKElDSDcgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMyIFs4MDg2OjI3Yzld
IChyZXYgMDIpCjAwOjFkLjIgVVNCIENvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMUcgKElDSDcgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICMzIFs4MDg2OjI3Y2Fd
IChyZXYgMDIpCjAwOjFkLjMgVVNCIENvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMUcgKElDSDcgRmFtaWx5KSBVU0IgVUhDSSBDb250cm9sbGVyICM0IFs4MDg2OjI3Y2Jd
IChyZXYgMDIpCjAwOjFkLjcgVVNCIENvbnRyb2xsZXIgWzBjMDNdOiBJbnRlbCBDb3Jwb3JhdGlv
biA4MjgwMUcgKElDSDcgRmFtaWx5KSBVU0IyIEVIQ0kgQ29udHJvbGxlciBbODA4NjoyN2NjXSAo
cmV2IDAyKQowMDoxZS4wIFBDSSBicmlkZ2UgWzA2MDRdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4Mjgw
MSBNb2JpbGUgUENJIEJyaWRnZSBbODA4NjoyNDQ4XSAocmV2IGUyKQowMDoxZi4wIElTQSBicmlk
Z2UgWzA2MDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUdCTSAoSUNINy1NKSBMUEMgSW50ZXJm
YWNlIEJyaWRnZSBbODA4NjoyN2I5XSAocmV2IDAyKQowMDoxZi4xIElERSBpbnRlcmZhY2UgWzAx
MDFdOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUcgKElDSDcgRmFtaWx5KSBJREUgQ29udHJvbGxl
ciBbODA4NjoyN2RmXSAocmV2IDAyKQowMDoxZi4yIElERSBpbnRlcmZhY2UgWzAxMDFdOiBJbnRl
bCBDb3Jwb3JhdGlvbiA4MjgwMUdCTS9HSE0gKElDSDcgRmFtaWx5KSBTQVRBIElERSBDb250cm9s
bGVyIFs4MDg2OjI3YzRdIChyZXYgMDIpCjAwOjFmLjMgU01CdXMgWzBjMDVdOiBJbnRlbCBDb3Jw
b3JhdGlvbiA4MjgwMUcgKElDSDcgRmFtaWx5KSBTTUJ1cyBDb250cm9sbGVyIFs4MDg2OjI3ZGFd
IChyZXYgMDIpCjAxOjAwLjAgVkdBIGNvbXBhdGlibGUgY29udHJvbGxlciBbMDMwMF06IEFUSSBU
ZWNobm9sb2dpZXMgSW5jIE01NlAgW1JhZGVvbiBNb2JpbGl0eSBYMTYwMF0gWzEwMDI6NzFjNV0K
MDI6MDAuMCBFdGhlcm5ldCBjb250cm9sbGVyIFswMjAwXTogTWFydmVsbCBUZWNobm9sb2d5IEdy
b3VwIEx0ZC4gODhFODA1MyBQQ0ktRSBHaWdhYml0IEV0aGVybmV0IENvbnRyb2xsZXIgWzExYWI6
NDM2Ml0gKHJldiAyMikKMDM6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXIgWzAyODBdOiBBdGhlcm9z
IENvbW11bmljYXRpb25zLCBJbmMuIEFSNTQxOCA4MDIuMTFhYmduIFdpcmVsZXNzIFBDSSBFeHBy
ZXNzIEFkYXB0ZXIgWzE2OGM6MDAyNF0gKHJldiAwMSkKMGM6MDMuMCBGaXJlV2lyZSAoSUVFRSAx
Mzk0KSBbMGMwMF06IFRleGFzIEluc3RydW1lbnRzIFRTQjgyQUEyIElFRUUtMTM5NGIgTGluayBM
YXllciBDb250cm9sbGVyIFsxMDRjOjgwMjVdIChyZXYgMDEpCg==
------=_Part_6979_33351618.1207183464442--
