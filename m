Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZDFORz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZDFORz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZDFORq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:17:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:57420 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZDFORp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DFtj+zTLkJkZOAUGc+jPaZFMi3jqb2FfyADibLhl25w7/oHrMcULu0ATHKu4BAD+7k
         XClWHV4nxnHiRQzGH8wNvAPzwPtbixr8Q7nDNbvthai2t5jPyGVM+ESOzp+ikOx38xZb
         W9rIILywbFC9RlYx0bCMlPMjSE0vxAE7GS0sE=
MIME-Version: 1.0
In-Reply-To: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
Date: Mon, 6 Apr 2009 23:17:43 +0900
Message-ID: <49b7c2350904060717l1a87cca7p880b6843ea92c702@mail.gmail.com>
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001636e0aedfd49bfb0466e38f77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0aedfd49bfb0466e38f77
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I attached patch file again because no-operation is changed
from "none"word to "nop" word.

for example,
-       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\=
n\n"
+       "wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop=
\n\n"

./trace_nop.c:struct tracer nop_trace __read_mostly =3D
	.name	=3D "nop",
	.init		=3D nop_trace_init,
	.reset	=3D nop_trace_reset,
	.selftest	=3D trace_selftest_startup_nop,
	.flags	=3D &nop_flags,
	.set_flag	=3D nop_set_flag



2009/4/6 GeunSik Lim <leemgs1@gmail.com>:
> =C2=A0 Dear Steven,
>
> =C2=A0 The author of ftrace(Internal kernel Function Tracer) feature
> renamed the ftrace tracer
> =C2=A0 =C2=A0to function to avoid further confusion between the ftrace
> infrastructure and the
> =C2=A0 =C2=A0function tracer on Oct-20, 2008.
>
> =C2=A0 =C2=A0But, Update of Mini-HOWTO document are still not working
> =C2=A0 =C2=A0.
> =C2=A0 =C2=A0Most of the developers often utilize "/debug/tracing/README"=
 file
> as Mini-HOWTO.
> =C2=A0 =C2=A0They will confuse definition and usage about ftrace =C2=A0be=
tween
> README(ftrace) file
> =C2=A0 =C2=A0and available_tracers(function) file after linux-2.6.27 like=
 me.
> =C2=A0 =C2=A0And, I want you to append "chrt -f 5 sleep 1" command as sim=
ple
> example for latency.
>
> =C2=A0 =C2=A0Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
> =C2=A0 =C2=A0Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> =C2=A0 =C2=A0Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
> =C2=A0kernel/trace/trace.c | =C2=A0 =C2=A03 ++-
> =C2=A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a0174a4..15f0eec 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2358,7 +2358,7 @@ static const char readme_msg[] =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# mkdir /debug\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# mount -t debugfs nodev /debug\n\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# cat /debug/tracing/available_tracers\n"
> - =C2=A0 =C2=A0 =C2=A0 "wakeup preemptirqsoff preemptoff irqsoff ftrace s=
ched_switch none\n\n"
> + =C2=A0 =C2=A0 =C2=A0 "wakeup preemptirqsoff preemptoff irqsoff function
> sched_switch none\n\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# cat /debug/tracing/current_tracer\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"none\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# echo sched_switch > /debug/tracing/current_=
tracer\n"
> @@ -2368,6 +2368,7 @@ static const char readme_msg[] =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"noprint-parent nosym-offset nosym-addr noverb=
ose\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# echo print-parent > /debug/tracing/trace_op=
tions\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# echo 1 > /debug/tracing/tracing_enabled\n"
> + =C2=A0 =C2=A0 =C2=A0 "# chrt -f 5 sleep 1\n"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"# cat /debug/tracing/trace > /tmp/trace.txt\n=
"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0"echo 0 > /debug/tracing/tracing_enabled\n"
> =C2=A0;
>
>
>
> --
> Regards,
> GeunSik Lim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>



--=20
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--001636e0aedfd49bfb0466e38f77
Content-Type: application/octet-stream; 
	name="update-minihowto-ftrace-nop.patch"
Content-Disposition: attachment; 
	filename="update-minihowto-ftrace-nop.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ft7s2dzr0

QXV0aG9yOiBHZXVuU2lrICBMaW08bGVlbWdzMUBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEFwciA2
IDIyOjQ4OjE2IDIwMDkgKzA5MDAKCiAgICBbUEFUQ0hdIFVwZGF0ZSBNaW5pLUhPV1RPIGZvciBm
dHJhY2UKICAgIAogICAgVGhlIGF1dGhvciBvZiBmdHJhY2UoSW50ZXJuYWwga2VybmVsIEZ1bmN0
aW9uIFRyYWNlcikgZmVhdHVyZSByZW5hbWVkIHRoZSBmdHJhY2UgdHJhY2VyCiAgICB0byBmdW5j
dGlvbiB0byBhdm9pZCBmdXJ0aGVyIGNvbmZ1c2lvbiBiZXR3ZWVuIHRoZSBmdHJhY2UgaW5mcmFz
dHJ1Y3R1cmUgYW5kIHRoZQogICAgZnVuY3Rpb24gdHJhY2VyIG9uIE9jdC0yMCwgMjAwOC4KICAg
IAogICAgQnV0LCBVcGRhdGUgb2YgTWluaS1IT1dUTyBkb2N1bWVudCBhcmUgc3RpbGwgbm90IHdv
cmtpbmcKICAgIC4KICAgIE1vc3Qgb2YgdGhlIGRldmVsb3BlcnMgb2Z0ZW4gdXRpbGl6ZSAiL2Rl
YnVnL3RyYWNpbmcvUkVBRE1FIiBmaWxlIGFzIE1pbmktSE9XVE8uCiAgICBUaGV5IHdpbGwgY29u
ZnVzZSBkZWZpbml0aW9uIGFuZCB1c2FnZSBhYm91dCBmdHJhY2UgIGJldHdlZW4gUkVBRE1FKGZ0
cmFjZSkgZmlsZQogICAgYW5kIGF2YWlsYWJsZV90cmFjZXJzKGZ1bmN0aW9uKSBmaWxlIGFmdGVy
IGxpbnV4LTIuNi4yNyBsaWtlIG1lLgogICAgQW5kLCBJIHdhbnQgeW91IHRvIGFwcGVuZCAiY2hy
dCAtZiA1IHNsZWVwIDEiIGNvbW1hbmQgYXMgc2ltcGxlIGV4YW1wbGUgZm9yIGxhdGVuY3kuCiAg
ICAKICAgIFNpZ25lZC1vZmYtYnk6IEdldW5TaWsgTGltIDxsZWVtZ3MxQGdtYWlsLmNvbT4KICAg
IFNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IDxzcm9zdGVkdEByZWRoYXQuY29tPgogICAg
U2lnbmVkLW9mZi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+Ci0tLQoga2VybmVsL3Ry
YWNlL3RyYWNlLmMgfCAgICAzICsrLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNlL3RyYWNlLmMgYi9rZXJu
ZWwvdHJhY2UvdHJhY2UuYwppbmRleCBhMDE3NGE0Li4xNWYwZWVjIDEwMDY0NAotLS0gYS9rZXJu
ZWwvdHJhY2UvdHJhY2UuYworKysgYi9rZXJuZWwvdHJhY2UvdHJhY2UuYwpAQCAtMjM1OCw3ICsy
MzU4LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgcmVhZG1lX21zZ1tdID0KICAgICAgICAiIyBta2Rp
ciAvZGVidWdcbiIKICAgICAgICAiIyBtb3VudCAtdCBkZWJ1Z2ZzIG5vZGV2IC9kZWJ1Z1xuXG4i
CiAgICAgICAgIiMgY2F0IC9kZWJ1Zy90cmFjaW5nL2F2YWlsYWJsZV90cmFjZXJzXG4iCi0gICAg
ICAgIndha2V1cCBwcmVlbXB0aXJxc29mZiBwcmVlbXB0b2ZmIGlycXNvZmYgZnRyYWNlIHNjaGVk
X3N3aXRjaCBub25lXG5cbiIKKyAgICAgICAid2FrZXVwIHByZWVtcHRpcnFzb2ZmIHByZWVtcHRv
ZmYgaXJxc29mZiBmdW5jdGlvbiBzY2hlZF9zd2l0Y2ggbm9wXG5cbiIKICAgICAgICAiIyBjYXQg
L2RlYnVnL3RyYWNpbmcvY3VycmVudF90cmFjZXJcbiIKICAgICAgICAibm9uZVxuIgogICAgICAg
ICIjIGVjaG8gc2NoZWRfc3dpdGNoID4gL2RlYnVnL3RyYWNpbmcvY3VycmVudF90cmFjZXJcbiIK
QEAgLTIzNjgsNiArMjM2OCw3IEBAIHN0YXRpYyBjb25zdCBjaGFyIHJlYWRtZV9tc2dbXSA9CiAg
ICAgICAgIm5vcHJpbnQtcGFyZW50IG5vc3ltLW9mZnNldCBub3N5bS1hZGRyIG5vdmVyYm9zZVxu
IgogICAgICAgICIjIGVjaG8gcHJpbnQtcGFyZW50ID4gL2RlYnVnL3RyYWNpbmcvdHJhY2Vfb3B0
aW9uc1xuIgogICAgICAgICIjIGVjaG8gMSA+IC9kZWJ1Zy90cmFjaW5nL3RyYWNpbmdfZW5hYmxl
ZFxuIgorICAgICAgICIjIGNocnQgLWYgNSBzbGVlcCAxXG4iCiAgICAgICAgIiMgY2F0IC9kZWJ1
Zy90cmFjaW5nL3RyYWNlID4gL3RtcC90cmFjZS50eHRcbiIKICAgICAgICAiZWNobyAwID4gL2Rl
YnVnL3RyYWNpbmcvdHJhY2luZ19lbmFibGVkXG4iCiA7CgoK
--001636e0aedfd49bfb0466e38f77--
