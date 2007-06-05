Return-Path: <linux-kernel-owner+w=401wt.eu-S1764871AbXFEOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764871AbXFEOUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764401AbXFEOUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:20:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:37189 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764298AbXFEOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:20:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=XwGdJoCEm/l6mWg0WEWFDRZizEW1c765IxB3wFEd6jlSLpaYirPpqXG5GXsNA7/HsJotGcgy6camgwoAqwAutHW8ShqPG4zCeXUAQNCo0QK26uAbZH/8cTADVvI2sR9v+4g1fsEnIqcDDZ5pfSNS17dL/PTOIf3Gz84S6RwNtOc=
Message-ID: <25ae38200706050720x6d691629na7657856513a2b97@mail.gmail.com>
Date: Tue, 5 Jun 2007 07:20:06 -0700
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: Patch related with Fork Bombing Atack
Cc: "Jiri Kosina" <jikos@jikos.cz>, Nix <nix@esperi.org.uk>,
       "Jens Axboe" <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org, "Kedar Sovani" <kedar@dreamzgroup.com>
In-Reply-To: <200706041128.35321.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_14344_33429176.1181053206293"
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
	 <25ae38200706040749o1eb3b7bbs64a09e6c2e4d7331@mail.gmail.com>
	 <Pine.LNX.4.64.0706041652130.24237@twin.jikos.cz>
	 <200706041128.35321.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_14344_33429176.1181053206293
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All
            I am forwarding one more improved patch related with fork
bombing attack. I have used printk_ratelimit function in my patch
and it works rellly well. it prints message as per printk_ratelimit
values stored in /proc/sys/kernel/printk_ratelimit
and /proc/sys/kernel/printk_ratelimit_burst.
root can set printk_ratelimit values(such as how many times message
should be repeated ,after how much time message should repeat) by
making changes in the above 2 mentioned files.
       this patch will never flood syslog anymore and will definitely
help administrator by informing him about fork bombing attack.
        added comments will help developers.

Regards,
Anand

On 6/4/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Monday 04 June 2007 10:58:41 Jiri Kosina wrote:
> > On Mon, 4 Jun 2007, Anand Jahagirdar wrote:
> > >            I am forwarding one improved patch related with Fork Bombing
> > > Attack. This patch prints a message (only once) which alerts
> > > administrator/root user about fork bombing attack. I created this patch
> > > to implement my idea of informing administrator about fork bombing
> > > attack on his machine only once.
> > >    This patch overcomes all drawbacks of my previous patch related with
> > > fork bombing attack and helps administrator. added comments will
> > > definitely help developers.
> > >
> > > +   /*
> > > +    * following code prints a message which alerts administrator/root               *
> > > user about fork bombing Attack +     */
> > > +   if ((atomic_read(&p->user->processes) >=
> > > (p->signal->rlim    [RLIMIT_NPROC].rlim_cur - 1)) &&
> > > (atomic_read(&p->user->processes) <
> > > p->signal->rlim[RLIMIT_NPROC].rlim_cur)) {
> >
> > Did this get malformed somehow? Looks like some successive lines got
> > pasted together, or something.
>
> Seeing the lack of the '+' I think it's a mangling from not paying attention
> to the 80 column marker in the editor.
>
> > > +           if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> > > p->user != &root_user) { +                  printk(KERN_CRIT"User with uid %d is
> > > crossing its Process limit\n",p->user->uid); +              }
> > > +   }
> >
> > Why not printk_ratelimit() here? Otherwise we have looped back to the
> > possibility of user flooding the system logs, which has been already
> > discussed in this thread, right?
> >
> > Also the { and } braces seem redundant.
> They are.
>
> Here's two hints:
> 1) double check for hidden "word wrap" problems. A sane programmers editor
> will alert you to this, and careful checking of the patches before posting
> will also reveal them. (emacs shows a \ in the 80th column, jed puts a $
> there, etc...)
> 2) when there is a potential for syslog spam - like your patch has - use
> printk_ratelimit() instead of printk(). This will throttle the output so that
> flooding the syslog is no longer possible.
>
> DRH
> ps: you patch is very difficult to apply - try using git
>

------=_Part_14344_33429176.1181053206293
Content-Type: text/plain; name=fork.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2l7kxc0
Content-Disposition: attachment; filename="fork.patch"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA2LTA1IDE5OjE2OjI4LjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDYt
MDUgMTk6MTg6MDcuMDAwMDAwMDAwICswNTMwCkBAIC05NTgsMTEgKzk1OCwxOCBAQAogCXJldHZh
bCA9IC1FQUdBSU47CiAJCiAKKwkvKgorICAgICAgICAgKiBmb2xsb3dpbmcgY29kZSBkb2VzIG5v
dCBhbGxvdyBOb24gUm9vdCBVc2VyIHRvIGNyb3NzIGl0cyBwcm9jZXNzCisgICAgICAgICAqIGxp
bWl0LiBpdCBhbGVydHMgYWRtaW5pc3RyYXRvciBhYm91dCBmb3JrIGJvbWJpbmcgYXR0YWNrIGFu
ZCBwcmV2ZW50cworICAgICAgICAgKiBpdC4KKyAgICAgICAgICovCiAJaWYgKGF0b21pY19yZWFk
KCZwLT51c2VyLT5wcm9jZXNzZXMpID49IHAtPnNpZ25hbC0+cmxpbVtSTElNSVRfTlBST0NdLnJs
aW1fY3VyKSAKIAkJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pICYmICFjYXBhYmxlKENBUF9T
WVNfUkVTT1VSQ0UpICYmCi0JCQkJcC0+dXNlciAhPSAmcm9vdF91c2VyKSAKLQkKKwkJCQlwLT51
c2VyICE9ICZyb290X3VzZXIpIHsKKwkJCWlmIChwcmludGtfcmF0ZWxpbWl0KCkpCisgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHByaW50ayhLRVJOX0NSSVQiVXNlciB3aXRoIHVpZCAl
ZCBpcyBjcm9zc2luZyBpdHMgcHJvY2VzcyBsaW1pdFxuIixwLT51c2VyLT51aWQpOwogCQkJZ290
byBiYWRfZm9ya19mcmVlOworCQl9CiAJCQkJCiAKIAlhdG9taWNfaW5jKCZwLT51c2VyLT5fX2Nv
dW50KTsK
------=_Part_14344_33429176.1181053206293--
