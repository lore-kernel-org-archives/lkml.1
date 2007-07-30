Return-Path: <linux-kernel-owner+w=401wt.eu-S938537AbXG3Foj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938537AbXG3Foj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbXG3Foc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:44:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbXG3Fob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:44:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:references;
	b=HiEIE4U8XZo8boiDk999ZuBAroXRilerTnU64m4vSj22nYHKvEsCEdY2enENFemdR
	jBSjIiPx7+QK0193g/BlQ==
Message-ID: <6599ad830707292244x3dbdf662l95de9bf3c1f5614e@mail.gmail.com>
Date: Sun, 29 Jul 2007 22:44:07 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1 -- INFO: possible recursive locking detected -- (&hashbin->hb_spinlock){....}, at: [<c03d95d3>] irias_seq_show+0xba/0x1a8
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Dag Brattli" <dagb@cs.uit.no>, samuel@sortiz.org
In-Reply-To: <20070728013859.5125f685.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_27739_17401820.1185774247576"
References: <a44ae5cd0707280001o54f479edqf1139c9c79c52ec9@mail.gmail.com>
	 <20070728013859.5125f685.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_27739_17401820.1185774247576
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >  [<c0154ad2>] proc_cpuset_show+0x5e/0xb9
> >  [<c01976b1>] seq_read+0xef/0x266
> >  [<c0181398>] vfs_read+0x8e/0x117
> >  [<c01817c9>] sys_read+0x3d/0x61
> >  [<c010401e>] sysenter_past_esp+0x5f/0x99
> >  =======================
> > INFO: lockdep is turned off.
> > Code: 00 89 d8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 08 89
> > 45 f0 89 55 ec 89 d3 01 cb 8d 43 ff c6 43 ff 00 8b 55 f0 8b 72 1c <8b>
> > 56 3c 29 d0 3b 45 ec 72 45 89 d1 c1 e9 02 8b 76 40 89 c7 f3
> > EIP: [<c01536a7>] container_path+0x20/0x7b SS:ESP 0068:c5ccff00
>

Oops, this is a case of trying to read /proc/self/cpuset when cpusets
are completely unmounted. It works fine when cpusets is mounted as
part of any hierarchy, or part of an active but unmounted hierarchy.
Attached patch fixes it, and should be rolled in to the first patch of
the series. (basic framework patch).

Paul

------=_Part_27739_17401820.1185774247576
Content-Type: text/x-patch; name=fix-proc-self-cpuset.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4qj4k0s
Content-Disposition: attachment; filename="fix-proc-self-cpuset.patch"

LS0tCiBrZXJuZWwvY29udGFpbmVyLmMgfCAgICA5ICsrKysrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDkgaW5zZXJ0aW9ucygrKQoKSW5kZXg6IGNvbnRhaW5lci0yLjYuMjItcmM2LW1tMS9rZXJuZWwv
Y29udGFpbmVyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gY29udGFpbmVyLTIuNi4yMi1yYzYtbW0xLm9yaWcv
a2VybmVsL2NvbnRhaW5lci5jCisrKyBjb250YWluZXItMi42LjIyLXJjNi1tbTEva2VybmVsL2Nv
bnRhaW5lci5jCkBAIC02ODQsNiArNjg0LDE1IEBAIGludCBjb250YWluZXJfcGF0aChjb25zdCBz
dHJ1Y3QgY29udGFpbmUKIHsKIAljaGFyICpzdGFydDsKIAorCWlmIChjb250ID09IGR1bW15dG9w
KSB7CisJCS8qCisJCSAqIEluYWN0aXZlIHN1YnN5c3RlbXMgaGF2ZSBubyBkZW50cnkgZm9yIHRo
ZWlyIHJvb3QKKwkJICogY29udGFpbmVyCisJCSAqLworCQlzdHJjcHkoYnVmLCAiLyIpOworCQly
ZXR1cm4gMDsKKwl9CisKIAlzdGFydCA9IGJ1ZiArIGJ1ZmxlbjsKIAogCSotLXN0YXJ0ID0gJ1ww
JzsK
------=_Part_27739_17401820.1185774247576--
