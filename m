Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXHVGRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXHVGRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXHVGRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:17:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:42126 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbXHVGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=YYyb/hj5j3qLYMMdpQv6l/zFwGr//GZFHfBkj1hcICwTTleYYiswjOs834tRCmKSC1w17UAaFBFV7LoeECzM4kvkLCkwAvrx7+S6ZJzmkKmNJHmagx5pgo8RTugVHFL9CZ3uca4AiPSLMApdv3qjibhi1rIL2dXNBmIQ7RB2G7I=
Message-ID: <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
Date: Wed, 22 Aug 2007 11:47:18 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Fork Bombing Patch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46C9A867.6090509@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_105094_15891374.1187763438922"
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <46C4BC46.7000305@redhat.com>
	 <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	 <46C9A867.6090509@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_105094_15891374.1187763438922
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi
   I am forwarding one more improved patch which i have modified as
per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
i have added one more if block to check hard limit. how good it is?

anand

On 8/20/07, Chris Snook <csnook@redhat.com> wrote:
> Anand Jahagirdar wrote:
> > Hi
> >    As Per the Previous Discussion of my Patch,I think insted of using
> > KERN_CRIT,it is better to lower the priority level to KERN_WARNING.
> > thats why i used KERN_WARNING.it will warn administrator and its
> > administrator responsibility to take whatever action he want to take.
> >
> > anand
>
> Philosophically, I'm okay with the idea of a forkbomb meriting KERN_WARN
> priority, but we should never have a printk that can be trivially triggered by
> an unprivileged user that gets anything higher than KERN_INFO.  If I'm an
> attacker, and I want to do bad things without getting logged, the first thing I
> do is launch a carefully-tuned forkbomb that doesn't bog down the system, just
> triggers this message as often as the ratelimit will allow.  Once /var/log is
> full, I can do my nastiness.  Administrators need to be able to protect against
> that kind of thing without losing the ability to log KERN_WARN and higher
> priority messages.
>
> Also, I stand by my assertion that we should only be complaining if the hard
> limit is also exceeded, since it's totally valid for an application to
> self-constrain using soft limits.  It may be uncommon, but the people who happen
> to use whatever applications do this will be very unhappy when they update their
> kernel and /var fills up from this spew.
>
>        -- Chris
>

------=_Part_105094_15891374.1187763438922
Content-Type: application/octet-stream; name=fork.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f5nfn6xi
Content-Disposition: attachment; filename="fork.patch"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA2LTI2IDIwOjQwOjA2LjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDYt
MjYgMjA6NDE6NDEuMDAwMDAwMDAwICswNTMwCkBAIC05NTcsMTIgKzk1NywxOSBAQAogCiAJcmV0
dmFsID0gLUVBR0FJTjsKIAkKLSAgICAgICAgCisgICAgICAgIC8qCisgICAgICAgICAqIGZvbGxv
d2luZyBjb2RlIGRvZXMgbm90IGFsbG93IE5vbiBSb290IFVzZXIgdG8gY3Jvc3MgaXRzIHByb2Nl
c3MKKyAgICAgICAgICogbGltaXQgYW5kIGl0IGFsZXJ0cyBhZG1pbmlzdHJhdG9yIGFib3V0IHVz
ZXIgTmVhcmluZyB0aGUgcHJvY2VzcyBsaW1pdC4KKyAgICAgICAgICovCisgCiAgICAgICAJaWYg
KGF0b21pY19yZWFkKCZwLT51c2VyLT5wcm9jZXNzZXMpID49IHAtPnNpZ25hbC0+cmxpbVtSTElN
SVRfTlBST0NdLnJsaW1fY3VyKSAKKwkJIGlmIChhdG9taWNfcmVhZCgmcC0+dXNlci0+cHJvY2Vz
c2VzKSA+PSBwLT5zaWduYWwtPnJsaW1bUkxJTUlUX05QUk9DXS5ybGltX21heCkKCSAJCWlmICgh
Y2FwYWJsZShDQVBfU1lTX0FETUlOKSAmJiAhY2FwYWJsZShDQVBfU1lTX1JFU09VUkNFKSAmJgot
CQkJCXAtPnVzZXIgIT0gJnJvb3RfdXNlcikgCisJCQkJcC0+dXNlciAhPSAmcm9vdF91c2VyKSAg
eworICAgICAgICAgICAgICAgICAgICAgICAgCWlmIChwcmludGtfcmF0ZWxpbWl0KCkpCisgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgCSBwcmludGsoS0VSTl9OT1RJQ0UgIlVzZXIgd2l0
aCB1aWQgJXUgaXMgTmVhcmluZyB0aGUgcHJvY2VzcyBsaW1pdFxuIixwLT51c2VyLT51aWQpOwor
CiAJCQkgCWdvdG8gYmFkX2ZvcmtfZnJlZTsKLQkJCQorCQkJfQkJCQogCQkJCiAJYXRvbWljX2lu
YygmcC0+dXNlci0+X19jb3VudCk7CiAJYXRvbWljX2luYygmcC0+dXNlci0+cHJvY2Vzc2VzKTsK

------=_Part_105094_15891374.1187763438922--
