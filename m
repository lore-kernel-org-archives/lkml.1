Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYDQHZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYDQHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYDQHZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:25:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39396 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYDQHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=J+8pqPv/CrloJoo1BAmpZjxITvJTBo4N/0wm8n0Eqp5sp+vjti7S00yS+hmZn6htfrJcFzACwK64584I+Vn+oXAFt3EPhUZsfRwZTfPrkNlBGXdcOfeNuisKYeH991MHnwB7rMravgqPvdVSPLng7ZBQEtzF7dXhNTZjq9fBrqE=
Message-ID: <aa79d98a0804170025u2ba1af66ja5bdd571063f69dd@mail.gmail.com>
Date: Thu, 17 Apr 2008 11:25:16 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: [patch 1/3] NFS: fix potential NULL pointer dereference
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <aa79d98a0804162125u45bde1edq550acf51784a5b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17002_203606.1208417116087"
References: <20080416174421.442716301@gmail.com>
	 <48063bc9.2234440a.747d.09ea@mx.google.com>
	 <1208369492.5376.9.camel@heimdal.trondhjem.org>
	 <20080416181336.GA7657@cvg>
	 <1208372123.5376.43.camel@heimdal.trondhjem.org>
	 <aa79d98a0804161319l4be9bb12k7bacae815b1d6d9c@mail.gmail.com>
	 <1208378428.8598.12.camel@heimdal.trondhjem.org>
	 <aa79d98a0804162125u45bde1edq550acf51784a5b5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17002_203606.1208417116087
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Apr 17, 2008 at 8:25 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Apr 17, 2008 at 12:40 AM, Trond Myklebust
>
> <trond.myklebust@fys.uio.no> wrote:
>  >
>
>
> >  On Thu, 2008-04-17 at 00:19 +0400, Cyrill Gorcunov wrote:
>  >  > Trond, I've just pointed the problem and its solution (which is seems
>  >  > to be a bit ugly, according to the rest nfs coding principle). So if
>  >  > you prefer to have such a check in 'walk_path' function - just say me
>  >  > that. You choose :) Thanks for comments
>  >
>  >
>  > > > So? The defensive coding principle is that you perform validity checks
>  >  > > when the pointer is created. Otherwise, we could equally well have added
>  >  > > the NULL deref check to nfs4_path_walk()...
>  >
>  >  No, your fix was correct, it was just incomplete.
>  >
>  >  The point I was making above was that defensive programming means that
>  >  _all_ these validity/NULL pointer checks should really be done in
>  >  nfs4_validate_mount_data and nfs_validate_mount_data. We shouldn't rely
>  >  on checks in other parts of the code.
>  >
>  >  In fact, as an example: it looks to me as if the lack of a
>  >  nfs_server.hostname, leads to a lack of nfs_client->cl_hostname, which
>  >  will eventually cause an Oops if you 'cat /proc/fs/nfsfs/servers', or if
>  >  you hit the printk in nfs_update_inode(), or various other dprintk()s.
>  >
>  >  Trond
>  >
>  >
>
>  Thanks Trond, I'll remake it ASAP (but can't guarantie that it will be soon ;)
>

Hi Trond,

here is an updated version enveloped (can't send it by inline 'cause I'm in
office now and have to use Web interface to my mail)

Please review (any comments are welcome - as always ;)

------=_Part_17002_203606.1208417116087
Content-Type: application/octet-stream; name=super.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff508zz80
Content-Disposition: attachment; filename=super.diff

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBnbWFpbC5jb20+ClN1YmplY3Q6IFtQQVRD
SF0gTkZTIC0gZml4IHBvc3NpYmxlIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZQoKa3N0cm5kdXAg
YW5kIGtzdHJkdXAgbWF5IHJldHVybiBOVUxMIHNvIHdlIHNob3VsZCBiZQpyZWFkeSBmb3IgYSBz
dWNoIHNpdHVhdGlvbgoKU2lnbmVkLW9mZi1ieTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBn
bWFpbC5jb20+CgotLS0KCi0tLSBhL2ZzL25mcy9zdXBlci5jCVdlZCBNYXIgMDUgMDc6MzM6NTQg
MjAwOAorKysgYS9mcy9uZnMvc3VwZXIuYwlUaHUgQXByIDE3IDExOjEwOjM0IDIwMDgKQEAgLTEy
MTEsNiArMTIxMSw4IEBAIHN0YXRpYyBpbnQgbmZzX3ZhbGlkYXRlX21vdW50X2RhdGEodm9pZCAK
IAkJCWFyZ3MtPm5mc19zZXJ2ZXIucHJvdG9jb2wgPSBYUFJUX1RSQU5TUE9SVF9VRFA7CiAJCS8q
IE4uQi4gY2FsbGVyIHdpbGwgZnJlZSBuZnNfc2VydmVyLmhvc3RuYW1lIGluIGFsbCBjYXNlcyAq
LwogCQlhcmdzLT5uZnNfc2VydmVyLmhvc3RuYW1lID0ga3N0cmR1cChkYXRhLT5ob3N0bmFtZSwg
R0ZQX0tFUk5FTCk7CisJCWlmICghYXJncy0+bmZzX3NlcnZlci5ob3N0bmFtZSkKKwkJCWdvdG8g
b3V0X25vbWVtOwogCQlhcmdzLT5uYW1sZW4JCT0gZGF0YS0+bmFtbGVuOwogCQlhcmdzLT5ic2l6
ZQkJPSBkYXRhLT5ic2l6ZTsKIAkJYXJncy0+YXV0aF9mbGF2b3JzWzBdCT0gZGF0YS0+cHNldWRv
Zmxhdm9yOwpAQCAtMTIzMyw2ICsxMjM1LDggQEAgc3RhdGljIGludCBuZnNfdmFsaWRhdGVfbW91
bnRfZGF0YSh2b2lkIAogCQlsZW4gPSBjIC0gZGV2X25hbWU7CiAJCS8qIE4uQi4gY2FsbGVyIHdp
bGwgZnJlZSBuZnNfc2VydmVyLmhvc3RuYW1lIGluIGFsbCBjYXNlcyAqLwogCQlhcmdzLT5uZnNf
c2VydmVyLmhvc3RuYW1lID0ga3N0cm5kdXAoZGV2X25hbWUsIGxlbiwgR0ZQX0tFUk5FTCk7CisJ
CWlmICghYXJncy0+bmZzX3NlcnZlci5ob3N0bmFtZSkKKwkJCWdvdG8gb3V0X25vbWVtOwogCiAJ
CWMrKzsKIAkJaWYgKHN0cmxlbihjKSA+IE5GU19NQVhQQVRITEVOKQpAQCAtMTI4MCw2ICsxMjg0
LDEwIEBAIG91dF9ub19hZGRyZXNzOgogCWRmcHJpbnRrKE1PVU5ULCAiTkZTOiBtb3VudCBwcm9n
cmFtIGRpZG4ndCBwYXNzIHJlbW90ZSBhZGRyZXNzXG4iKTsKIAlyZXR1cm4gLUVJTlZBTDsKIAor
b3V0X25vbWVtOgorCWRmcHJpbnRrKE1PVU5ULCAiTkZTOiBub3QgZW5vdWdoIG1lbW9yeSB0byBk
dXBsaWNhdGUgc3RyaW5nXG4iKTsKKwlyZXR1cm4gLUVOT01FTTsKKwogb3V0X2ludmFsaWRfZmg6
CiAJZGZwcmludGsoTU9VTlQsICJORlM6IGludmFsaWQgcm9vdCBmaWxlaGFuZGxlXG4iKTsKIAly
ZXR1cm4gLUVJTlZBTDsKQEAgLTE3OTcsMTIgKzE4MDUsMTUgQEAgc3RhdGljIGludCBuZnM0X3Zh
bGlkYXRlX21vdW50X2RhdGEodm9pZAogCQkJcmV0dXJuIC1FTkFNRVRPT0xPTkc7CiAJCS8qIE4u
Qi4gY2FsbGVyIHdpbGwgZnJlZSBuZnNfc2VydmVyLmhvc3RuYW1lIGluIGFsbCBjYXNlcyAqLwog
CQlhcmdzLT5uZnNfc2VydmVyLmhvc3RuYW1lID0ga3N0cm5kdXAoZGV2X25hbWUsIGxlbiwgR0ZQ
X0tFUk5FTCk7Ci0KKwkJaWYgKCFhcmdzLT5uZnNfc2VydmVyLmhvc3RuYW1lKQorCQkJZ290byBv
dXRfbm9tZW07CiAJCWMrKzsJCQkvKiBzdGVwIG92ZXIgdGhlICc6JyAqLwogCQlsZW4gPSBzdHJs
ZW4oYyk7CiAJCWlmIChsZW4gPiBORlM0X01BWFBBVEhMRU4pCiAJCQlyZXR1cm4gLUVOQU1FVE9P
TE9ORzsKIAkJYXJncy0+bmZzX3NlcnZlci5leHBvcnRfcGF0aCA9IGtzdHJuZHVwKGMsIGxlbiwg
R0ZQX0tFUk5FTCk7CisJCWlmICghYXJncy0+bmZzX3NlcnZlci5leHBvcnRfcGF0aCkKKwkJCWdv
dG8gb3V0X25vbWVtOwogCiAJCWRwcmludGsoIk5GUzogTU5UUEFUSDogJyVzJ1xuIiwgYXJncy0+
bmZzX3NlcnZlci5leHBvcnRfcGF0aCk7CiAKQEAgLTE4MjcsNiArMTgzOCwxMCBAQCBvdXRfaW52
YWxfYXV0aDoKIG91dF9ub19hZGRyZXNzOgogCWRmcHJpbnRrKE1PVU5ULCAiTkZTNDogbW91bnQg
cHJvZ3JhbSBkaWRuJ3QgcGFzcyByZW1vdGUgYWRkcmVzc1xuIik7CiAJcmV0dXJuIC1FSU5WQUw7
CisKK291dF9ub21lbToKKwlkZnByaW50ayhNT1VOVCwgIk5GUzQ6IG5vdCBlbm91Z2ggbWVtb3J5
IHRvIGR1cGxpY2F0ZSBzdHJpbmdcbiIpOworCXJldHVybiAtRU5PTUVNOwogCiBvdXRfbm9fY2xp
ZW50X2FkZHJlc3M6CiAJZGZwcmludGsoTU9VTlQsICJORlM0OiBtb3VudCBwcm9ncmFtIGRpZG4n
dCBwYXNzIGNhbGxiYWNrIGFkZHJlc3NcbiIpOwo=
------=_Part_17002_203606.1208417116087--
