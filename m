Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbYDKSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbYDKSWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759846AbYDKSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:22:10 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:61240 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbYDKSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=fVnNljZO1PuCVdF7ugm3GDZh08gh52R/hfjvDg/FsgnBXO+Ri1W/w+EuSJXVJLGl6vRYS7r3riU8H5pQsxKZvVZBN/+NAjh0Faiykxk3M2FcddslEN/z1y20YH/9c7PPlivwQ5xbn4ScxsPxoJwBT5rVKuOHVFgTbXwDDRP8EFk=
Message-ID: <86802c440804111122x5c106779g60f1c04ae21fed94@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:22:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1207899030.15605.1.camel@x61.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20949_28947596.1207938128045"
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	 <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
	 <1207899030.15605.1.camel@x61.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20949_28947596.1207938128045
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Apr 11, 2008 at 12:30 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
>
>  On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
>  > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  > >  >  > last week found:
>  > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  > >  >  > forcedeth doesn't work anymore.
>  > >  >  >
>  > >  >  > I stared at forcedeth.c two days. and revert every patches about that
>  > >  >  > doesn't help.
>  > >  >
>  > >  >  So forcedeth does not come up again, when you kexec from linus.git
>  > >  >  into an older distro kernel. Or is it the other way round ?
>  > >  RHEL 5.1 kexec RHEL 5.1 : works
>  > >  RHEL 5.1 kexec linus kernel: works
>  > >  linus (after -rc2) kexec linus tree: works:
>  > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
>  > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
>  > >
>  > the forcedeth can not get IP address...
>
>  Sounds like you are not getting any interrupts when you receive a
>  packet.  (i.e. The interrupt line is staying disabled).
>
>  Is MSI an option here?  I'm wondering if we disable the MSI and
>  something is not enabling it.



after
setpci -s 0x00:08.0 0x60.b=0xfe

the eth0 can get ip address with ifup eth0.

YH

------=_Part_20949_28947596.1207938128045
Content-Type: text/plain; name=not_works.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fex393m00
Content-Disposition: attachment; filename=not_works.txt

MDA6MDguMCBCcmlkZ2U6IG5WaWRpYSBDb3Jwb3JhdGlvbiBNQ1A1NSBFdGhlcm5ldCAocmV2IGEz
KQoJU3Vic3lzdGVtOiBuVmlkaWEgQ29ycG9yYXRpb24gVW5rbm93biBkZXZpY2UgY2I4NAoJQ29u
dHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0KCVN0YXR1czogQ2FwKyA2Nk1IeisgVURG
LSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0KCUxhdGVuY3k6IDAgKDI1MG5zIG1pbiwgNTAwMG5zIG1heCkKCUludGVy
cnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAyMzMKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZGVmYmEw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglSZWdpb24gMTogSS9PIHBv
cnRzIGF0IDg0MDAgW3NpemU9OF0KCVJlZ2lvbiAyOiBNZW1vcnkgYXQgZGVmYmU4MDAgKDMyLWJp
dCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MjU2XQoJUmVnaW9uIDM6IE1lbW9yeSBhdCBkZWZi
ZTQwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNl0KCUNhcGFiaWxpdGllczog
WzQ0XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEr
IEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJU3Rh
dHVzOiBEMCBQTUUtRW5hYmxlKyBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBb
NzBdIE1TSS1YOiBFbmFibGUtIE1hc2stIFRhYlNpemU9OAoJCVZlY3RvciB0YWJsZTogQkFSPTIg
b2Zmc2V0PTAwMDAwMDAwCgkJUEJBOiBCQVI9MyBvZmZzZXQ9MDAwMDAwMDAKCUNhcGFiaWxpdGll
czogWzUwXSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiA2NGJpdCsgUXVldWU9MC8zIEVu
YWJsZS0KCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTA0MDAwICBEYXRhOiA0MDZhCglDYXBhYmlsaXRp
ZXM6IFs2Y10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBwaW5nCjAwOiBkZSAxMCA3MyAwMyAwNyAw
MCBiMCAwMCBhMyAwMCA4MCAwNiAwMCAwMCAwMCAwMAoxMDogMDAgYTAgZmIgZGUgMDEgODQgMDAg
MDAgMDAgZTggZmIgZGUgMDAgZTQgZmIgZGUKMjA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIGRlIDEwIDg0IGNiCjMwOiAwMCAwMCAwMCAwMCA0NCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwYSAwMSAwMSAxNAo0MDogZGUgMTAgODQgY2IgMDEgNzAgMDIgZmUgMDAgMDEgMDAgMDAg
MGMgMDAgMDAgMDAKNTA6IDA1IDZjIDg2IDAxIDAwIDQwIGUwIGZlIDAwIDAwIDAwIDAwIDZhIDQw
IDAwIDAwCjYwOiBmZiAwMCAwMCAwMCAwMCAwMCAwMCAwMCBmZiAwMCAwMCAwMCAwOCAwMCAwMyBh
OAo3MDogMTEgNTAgMDcgMDAgMDIgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKODA6
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCjkwOiAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAphMDogMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYjA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApkMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwCmYwOiAwMCAwMCAwMCAwMCAxMSAwMCAwMCAwMCA1MiAwMSAwMCAw
MCAwMCAwMCAwMCAwMAoK
------=_Part_20949_28947596.1207938128045
Content-Type: text/plain; name=works.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fex39q3q1
Content-Disposition: attachment; filename=works.txt

MDA6MDguMCBCcmlkZ2U6IG5WaWRpYSBDb3Jwb3JhdGlvbiBNQ1A1NSBFdGhlcm5ldCAocmV2IGEz
KQoJU3Vic3lzdGVtOiBuVmlkaWEgQ29ycG9yYXRpb24gVW5rbm93biBkZXZpY2UgY2I4NAoJQ29u
dHJvbDogSS9PKyBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0g
UGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0KCVN0YXR1czogQ2FwKyA2Nk1IeisgVURG
LSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQt
ID5TRVJSLSA8UEVSUi0KCUxhdGVuY3k6IDAgKDI1MG5zIG1pbiwgNTAwMG5zIG1heCkKCUludGVy
cnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxMDYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgZGVmYmEw
MDAgKDMyLWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglSZWdpb24gMTogSS9PIHBv
cnRzIGF0IDg0MDAgW3NpemU9OF0KCVJlZ2lvbiAyOiBNZW1vcnkgYXQgZGVmYmU4MDAgKDMyLWJp
dCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MjU2XQoJUmVnaW9uIDM6IE1lbW9yeSBhdCBkZWZi
ZTQwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNl0KCUNhcGFiaWxpdGllczog
WzQ0XSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMgoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEr
IEQyKyBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxKyxEMissRDNob3QrLEQzY29sZCspCgkJU3Rh
dHVzOiBEMCBQTUUtRW5hYmxlKyBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBb
NzBdIE1TSS1YOiBFbmFibGUtIE1hc2stIFRhYlNpemU9OAoJCVZlY3RvciB0YWJsZTogQkFSPTIg
b2Zmc2V0PTAwMDAwMDAwCgkJUEJBOiBCQVI9MyBvZmZzZXQ9MDAwMDAwMDAKCUNhcGFiaWxpdGll
czogWzUwXSBNZXNzYWdlIFNpZ25hbGxlZCBJbnRlcnJ1cHRzOiA2NGJpdCsgUXVldWU9MC8zIEVu
YWJsZSsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTA3MDAwICBEYXRhOiA0MDZhCglDYXBhYmlsaXRp
ZXM6IFs2Y10gSHlwZXJUcmFuc3BvcnQ6IE1TSSBNYXBwaW5nCjAwOiBkZSAxMCA3MyAwMyAwNyAw
MCBiMCAwMCBhMyAwMCA4MCAwNiAwMCAwMCAwMCAwMAoxMDogMDAgYTAgZmIgZGUgMDEgODQgMDAg
MDAgMDAgZTggZmIgZGUgMDAgZTQgZmIgZGUKMjA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIGRlIDEwIDg0IGNiCjMwOiAwMCAwMCAwMCAwMCA0NCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwYSAwMSAwMSAxNAo0MDogZGUgMTAgODQgY2IgMDEgNzAgMDIgZmUgMDAgMDEgMDAgMDAg
MGMgMDAgMDAgMDAKNTA6IDA1IDZjIDg3IDAxIDAwIDcwIGUwIGZlIDAwIDAwIDAwIDAwIDZhIDQw
IDAwIDAwCjYwOiBmZSAwMCAwMCAwMCAwMCAwMCAwMCAwMCBmZiAwMCAwMCAwMCAwOCAwMCAwMyBh
OAo3MDogMTEgNTAgMDcgMDAgMDIgMDAgMDAgMDAgMDMgMDAgMDAgMDAgMDAgMDAgMDAgMDAKODA6
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCjkwOiAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMAphMDogMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKYjA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwCmMwOiAwMCAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMApkMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAKZTA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwCmYwOiAwMCAwMCAwMCAwMCAxMSAwMCAwMCAwMCA1MiAwMSAwMCAw
MCAwMCAwMCAwMCAwMAoK
------=_Part_20949_28947596.1207938128045--
