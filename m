Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569Ab0AZJin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0AZJin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323Ab0AZJik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:38:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:41674 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0AZJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l+GdlGtSxzIIKtsJE9iTziLBUbJ9aaW+QMp1dFam0+lvkIsaCSUS+wIr2nrLrzPjCB
         yZ4vuKj1iVr99Dbvh4Qu4LSMlV4+43tXJd3t8qmGfHZldHpfH8nAYvJUvjQhKelKgaPD
         6B3c5abVC6aLns682zBkRxHQnP1CPsJOcBG3s=
MIME-Version: 1.0
In-Reply-To: <m1vdepxm6w.fsf@fess.ebiederm.org>
References: <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com>
	 <20100126060705.GF19799@ZenIV.linux.org.uk>
	 <20100126164018.1D59.A69D9226@jp.fujitsu.com>
	 <2375c9f91001260045s7d01c427g64bc10f5bf4db4d@mail.gmail.com>
	 <m1vdepxm6w.fsf@fess.ebiederm.org>
Date: Tue, 26 Jan 2010 17:32:59 +0800
Message-ID: <2375c9f91001260132l21e43fc4v2eed9ac39f433b8d@mail.gmail.com>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed; boundary=00c09f8de004bf5cf5047e0df8c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00c09f8de004bf5cf5047e0df8c6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26, 2010 at 5:14 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Am=C3=A9rico Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Tue, Jan 26, 2010 at 3:45 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>> Hi
>>>
>>>> On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:
>>>>
>>>> > I agree, it seems that patch is useless, since we already
>>>> > do lock_kernel() before calling __f_setown()...
>>>>
>>>> What's to prevent pid from being freed under us? =C2=A0BKL won't...
>>>
>>> I don't understand this issue at all. so, this is stupid dumb question.
>>> Why can't we write following code?
>>>
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum pid_type ty=
pe;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct pid *pid;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!waitqueue_a=
ctive(&tty->read_wait))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0tty->minimum_to_wake =3D 1;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsav=
e(&tty->ctrl_lock, flags);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tty->pgrp) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pid =3D tty->pgrp;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0type =3D PIDTYPE_PGID;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0pid =3D task_pid(current);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0type =3D PIDTYPE_PID;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0get_pid(pid) =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0// insert here
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqr=
estore(&tty->ctrl_lock, flags);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D __f_s=
etown(filp, pid, type, 0);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0put_pid(pid) =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0// insert here
>>>
>>
>> Yeah, this seems reasonable for me, but not sure if this is the best fix=
.
>
> That or tweak __f_setown to use irqsave/irqrestore variants for it's
> locks, __f_setown is already atomic. =C2=A0I prefer that direction becaus=
e the
> code is just a little simpler.
>

Oh, very good advice!

Patch is below.

-------------->
Commit 703625118 causes a lockdep warning:

[ INFO: possible irq lock inversion dependency detected ]
2.6.33-rc5 #77
---------------------------------------------------------
emacs/1609 just changed the state of lock:
 (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>]
tty_fasync+0xe8/0x190
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&sighand->siglock)->rlock){-.....}

This is due to we use write_lock_irq() in __f_setown() which turns
the IRQ on in write_unlock_irq(), causes this warning.

Switch it ot write_lock_irqsave() and write_unlock_irqrestore(),
as suggested by Eric.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

----

--00c09f8de004bf5cf5047e0df8c6
Content-Type: text/plain; charset=US-ASCII; 
	name="fs-fcntl-__f_setown_use-irqsave-lock.diff"
Content-Disposition: attachment; 
	filename="fs-fcntl-__f_setown_use-irqsave-lock.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g4whmj4z0

ZGlmZiAtLWdpdCBhL2ZzL2ZjbnRsLmMgYi9mcy9mY250bC5jCmluZGV4IDk3ZTAxZGMuLjU1NmI0
MDQgMTAwNjQ0Ci0tLSBhL2ZzL2ZjbnRsLmMKKysrIGIvZnMvZmNudGwuYwpAQCAtMTk5LDcgKzE5
OSw4IEBAIHN0YXRpYyBpbnQgc2V0ZmwoaW50IGZkLCBzdHJ1Y3QgZmlsZSAqIGZpbHAsIHVuc2ln
bmVkIGxvbmcgYXJnKQogc3RhdGljIHZvaWQgZl9tb2Rvd24oc3RydWN0IGZpbGUgKmZpbHAsIHN0
cnVjdCBwaWQgKnBpZCwgZW51bSBwaWRfdHlwZSB0eXBlLAogICAgICAgICAgICAgICAgICAgICAg
aW50IGZvcmNlKQogewotCXdyaXRlX2xvY2tfaXJxKCZmaWxwLT5mX293bmVyLmxvY2spOworCWlu
dCBmbGFnczsKKwl3cml0ZV9sb2NrX2lycXNhdmUoJmZpbHAtPmZfb3duZXIubG9jaywgZmxhZ3Mp
OwogCWlmIChmb3JjZSB8fCAhZmlscC0+Zl9vd25lci5waWQpIHsKIAkJcHV0X3BpZChmaWxwLT5m
X293bmVyLnBpZCk7CiAJCWZpbHAtPmZfb3duZXIucGlkID0gZ2V0X3BpZChwaWQpOwpAQCAtMjEx
LDcgKzIxMiw3IEBAIHN0YXRpYyB2b2lkIGZfbW9kb3duKHN0cnVjdCBmaWxlICpmaWxwLCBzdHJ1
Y3QgcGlkICpwaWQsIGVudW0gcGlkX3R5cGUgdHlwZSwKIAkJCWZpbHAtPmZfb3duZXIuZXVpZCA9
IGNyZWQtPmV1aWQ7CiAJCX0KIAl9Ci0Jd3JpdGVfdW5sb2NrX2lycSgmZmlscC0+Zl9vd25lci5s
b2NrKTsKKwl3cml0ZV91bmxvY2tfaXJxcmVzdG9yZSgmZmlscC0+Zl9vd25lci5sb2NrLCBmbGFn
cyk7CiB9CiAKIGludCBfX2Zfc2V0b3duKHN0cnVjdCBmaWxlICpmaWxwLCBzdHJ1Y3QgcGlkICpw
aWQsIGVudW0gcGlkX3R5cGUgdHlwZSwK
--00c09f8de004bf5cf5047e0df8c6--
