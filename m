Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYBFTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYBFTlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYBFTlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:41:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:2518 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYBFTlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=FzeqvRE7bi/nkaTLVRXwpvLSGm4P1RdMyoG/IzaoeSkIJZlyDHzGxt0u/DIJReYsuzd9vENyp8CrBPh+kIhmeuEgDwZ5kVLrTHtDTJ+yU6O9y1cmie4LpTuRc6jQJ4mwyH9JhdLlDDShPvSCR0BvruYDzGznQqss20CLiZvGfig=
Message-ID: <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
Date: Wed, 6 Feb 2008 14:40:58 -0500
From: "Clem Taylor" <clem.taylor@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch descriptor leak?]
Cc: linux-kernel@vger.kernel.org, "Amy Griffis" <amy.griffis@hp.com>
In-Reply-To: <20080206015103.9a0f4069.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16200_26064573.1202326858446"
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com>
	 <20080206015103.9a0f4069.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16200_26064573.1202326858446
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Feb 6, 2008 4:51 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 5 Feb 2008 20:49:42 -0500 "Clem Taylor" <clem.taylor@gmail.com> wrote:
> > I'm trying to move a MIPS based embedded system from 2.6.16.16 to
> > 2.6.24. Most things seem to be working, but I'm having troubles with
> > inotify. The code is using inotify to detect a file written to /tmp
> > (tmpfs). The writer creates a file with a temporary name and then
> > rename()s the tmp file over the file I'm monitoring.
> >
> > With 2.6.16.16, everything works fine, but with 2.6.24, the inotify
> > process runs for a while (~100 events) and then inotify_add_watch()
> > returns ENOSPC. Once this happens, I can't add new watches, even if I
> > kill the process and restart it. fs.inotify.max_user_instances and
> > fs.inotify.max_user_watches are both 128, so I'd imagine I'm hitting
> > this limit. For some reason the watches aren't getting cleaned up
> > (even after the process is killed).

> Good bug report, thanks.  That code was significantly altered in June 2006
> and perhaps something broke.

I also tested on a 2.6.20 x86 desktop machine. It took ~8k iterations
to fail, which matched max_user_watches. Once the program fails, it
will fail right away if it is re-run.

> It's a bit hard to find people who work on inotify, I'm afraid.  If you had
> the time to come up with a script or program which demonstrates the bug,
> that would be super-helpful?

Attached is a simple example that shows off the problem. On a system
with a problem, it will only run for about
fs.inotify.max_user_watches iterations. If everything is working, it
should run forever.

                                 Thanks,
                                 Clem

------=_Part_16200_26064573.1202326858446
Content-Type: text/x-csrc; name=inotifyLeak.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcca8dcy0
Content-Disposition: attachment; filename=inotifyLeak.c

LyogSW5vdGlmeSBJTl9PTkVTSE9UIGxlYWs/CiAqCiAqIFRoaXMgcHJvZ3JhbSBsb29wcyBvbiBj
cmVhdGluZyBvbmVzaG90IGlub3RpZnkgd2F0Y2hlcywgdHJpZ2dlcmluZyBhIGNsb3NlCiAqIHdy
aXRlIGV2ZW50IGFuZCB0aGVuIHdhaXRpbmcgZm9yIHRoZSBldmVudC4gIE9uIDIuNi4xNi4xNiB0
aGlzIHdvcmtzIGp1c3QKICogZmluZS4gIFdoZW4gSSBtb3ZlZCB0byAyLjYuMjQsIHRoaXMgY29k
ZSBmYWlscyBhZnRlciB+MTAwIGV2ZW50cy4KICogZnMuaW5vdGlmeS5tYXhfdXNlcl9pbnN0YW5j
ZXMgYW5kIGZzLmlub3RpZnkubWF4X3VzZXJfd2F0Y2hlcyBhcmUgYm90aCAxMjgsCiAqIHNvIEkn
ZCBpbWFnaW5lIEkgYW0gaGl0dGluZyB0aGlzIGxpbWl0LgogKgogKiBBZnRlciBraWxsaW5nIGFu
ZCByZXN0YXJ0aW5nIHRoZSBwcm9ibGVtLCBpdCB3aWxsIGZhaWwgcmlnaHQgYXdheSBhbmQgb25s
eQogKiBhIHJlYm9vdCB3aWxsIHJlY292ZXIuCiAqCiAqIFRoaXMgYWxzbyBmYWlscyBvbiBhIGRl
c2t0b3AgbWFjaGluZSB3aXRoIDIuNi4yMC4gSXQgdG9vayB+OGsgaXRlcmF0aW9ucwogKiB0byBm
YWlsLCB3aGljaCBtYXRjaGVzIHRoZSBsYXJnZXIgbWF4X3VzZXJfd2F0Y2hlcy4KICoKICogQ29t
cGlsZSB3aXRoOgogKiBnY2MgLVdhbGwgLW8gaW5vdGlmeUxlYWsgaW5vdGlmeUxlYWsuYwogKgog
KiBXb3JrZWQgaW4gMi42LjE2LjE2IFttaXBzZWxdCiAqIEZhaWxzIGluIDIuNi4yMCBbRmVkb3Jh
IHg4Nl0KICogRmFpbHMgaW4gMi42LjI0IFttaXBzZWxdCiAqLwojaW5jbHVkZSA8c3RkbGliLmg+
CiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzdHJpbmcu
aD4KI2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxzeXMvaW5vdGlmeS5oPgojaW5jbHVkZSA8
c3lzL3RpbWUuaD4KCi8qIG1ha2VGaWxlKCk6IENyZWF0ZSBhIGNsb3NlIHdyaXRlIGV2ZW50IGZv
ciBpbm90aWZ5IHRvIGRldGVjdC4gKi8KaW50IG1ha2VGaWxlICggY29uc3QgY2hhciAqZmlsZW5h
bWUgKQp7CiAgICBGSUxFICpmaWxlOwogICAgc3RydWN0IHRpbWV2YWwgdHY7CgogICAgZ2V0dGlt
ZW9mZGF5ICggJnR2LCBOVUxMICk7CgogICAgZmlsZSA9IGZvcGVuICggZmlsZW5hbWUsICJ3IiAp
OwogICAgaWYgKCBmaWxlID09IE5VTEwgKQogICAgewogICAgICAgIGZwcmludGYgKCBzdGRlcnIs
ICJGYWlsZWQgdG8gb3BlbiBcIiVzXCIgZm9yIHdyaXRpbmc6ICVzXG4iLAogICAgICAgICAgICBm
aWxlbmFtZSwgc3RyZXJyb3IgKCBlcnJubyApICk7CiAgICAgICAgcmV0dXJuIC0xOwogICAgfQoK
ICAgIGZwcmludGYgKCBmaWxlLCAiJXUuJTA2ZFxuIiwgKHVuc2lnbmVkIGludCkgdHYudHZfc2Vj
LCAoaW50KSB0di50dl91c2VjICk7CiAgICBmY2xvc2UgKCBmaWxlICk7CgogICAgcmV0dXJuIDA7
Cn0KCmludCBtYWluICggaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSApCnsKICAgIGNvbnN0IGNoYXIg
ZmlsZW5hbWVbXSA9ICIvdG1wL2lub3RpZnlMZWFrLnRlc3QiOwogICAgc3RydWN0IGlub3RpZnlf
ZXZlbnQgZXZlbnQ7CiAgICBpbnQgbm90aWZ5RkQsIHdkLCByZXQsIGk7CgogICAgaWYgKCAoIG5v
dGlmeUZEID0gaW5vdGlmeV9pbml0KCkgKSA8IDAgKQogICAgewogICAgICAgIGZwcmludGYgKCBz
dGRlcnIsICJpbm90aWZ5X2luaXQoKSBmYWlsZWQ6ICVzXG4iLCBzdHJlcnJvciAoIGVycm5vICkg
KTsKICAgICAgICByZXR1cm4gMTsKICAgIH0KCiAgICAvKiBjcmVhdGUgaW5pdGlhbCBmaWxlICov
CiAgICBtYWtlRmlsZSAoIGZpbGVuYW1lICk7CgogICAgZm9yICggaSA9IDAgOyA7IGkrKyApCiAg
ICB7CiAgICAgICAgLyogY3JlYXRlIGEgb25lIHNob3QgZXZlbnQgKi8KICAgICAgICB3ZCA9IGlu
b3RpZnlfYWRkX3dhdGNoICggbm90aWZ5RkQsIGZpbGVuYW1lLAogICAgICAgICAgICBJTl9DTE9T
RV9XUklURSB8IElOX0RFTEVURV9TRUxGIHwgSU5fT05FU0hPVCApOwogICAgICAgIGlmICggd2Qg
PCAwICkKICAgICAgICB7CiAgICAgICAgICAgIC8qIHRoaXMgaXMgdGhlIGZhaWx1cmUgY2FzZSAq
LwogICAgICAgICAgICBmcHJpbnRmICggc3RkZXJyLCAiaW5vdGlmeV9hZGRfd2F0Y2goKSBmYWls
ZWQ6ICVzIFtpPSVkXVxuIiwKICAgICAgICAgICAgICAgIHN0cmVycm9yICggZXJybm8gKSwgaSAp
OwogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICB9CgogICAgICAgIC8qIGNyZWF0ZSBhbiBl
dmVudCBvbiB0aGUgZmlsZSAqLwogICAgICAgIG1ha2VGaWxlICggZmlsZW5hbWUgKTsKCiAgICAg
ICAgLyogYmxvY2tpbmcgcmVhZCwgd2FpdGluZyBmb3IgZXZlbnQgKi8KICAgICAgICByZXQgPSBy
ZWFkICggbm90aWZ5RkQsICZldmVudCwgc2l6ZW9mKGV2ZW50KSApOwogICAgICAgIGlmICggcmV0
IDwgMCApCiAgICAgICAgewogICAgICAgICAgICBmcHJpbnRmICggc3RkZXJyLCAiaW5vdGlmeSBy
ZWFkKCkgZmFpbGVkOiAlc1xuIiwKICAgICAgICAgICAgICAgIHN0cmVycm9yICggZXJybm8gKSAp
OwogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICB9CiAgICAgICAgZWxzZSBpZiAoIHJldCAh
PSBzaXplb2YoZXZlbnQpICkKICAgICAgICB7CiAgICAgICAgICAgIGZwcmludGYgKCBzdGRlcnIs
ICJpbm90aWZ5IHJlYWQoKSByZXR1cm5lZCAlZCBub3QgJWRcbiIsCiAgICAgICAgICAgICAgICBy
ZXQsIHNpemVvZihldmVudCkgKTsKICAgICAgICAgICAgcmV0dXJuIDE7CiAgICAgICAgfQogICAg
ICAgIGVsc2UgaWYgKCBldmVudC53ZCAhPSB3ZCApCiAgICAgICAgewogICAgICAgICAgICBmcHJp
bnRmICggc3RkZXJyLCAiV2F0Y2ggbWlzbWF0Y2gsIGV4cGVjdGVkICVkLCBnb3QgJWRcbiIsCiAg
ICAgICAgICAgICAgICB3ZCwgZXZlbnQud2QgKTsKICAgICAgICAgICAgcmV0dXJuIDE7CiAgICAg
ICAgfQoKICAgICAgICAvKiBpZiB3ZSBhdHRlbXB0IHRvIGNhbGwgaW5vdGlmeV9ybV93YXRjaCgp
LCBoZXJlIHdlIGdldCBFSU5WQUwsCiAgICAgICAgICogd2hpY2ggaXMgZXhwZWN0ZWQgYmVjYXVz
ZSB0aGUgd2F0Y2ggc2hvdWxkIGhhdmUgYmVlbiBkZWxldGVkCiAgICAgICAgICogb25jZSB0aGUg
ZXZlbnQgaXMgdHJpZ2dlcmVkLgogICAgICAgICAqLwoKICAgICAgICAvKiBwcm9ncmVzcyByZXBv
cnQuLi4gKi8KICAgICAgICBmcHJpbnRmICggc3RkZXJyLCAiICVkIDogJWQgIFxyIiwgaSwgd2Qg
KTsKICAgIH0KCiAgICByZXR1cm4gMDsKfQo=
------=_Part_16200_26064573.1202326858446--
