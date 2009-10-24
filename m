Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZJXWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZJXWYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 18:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZJXWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 18:24:14 -0400
Received: from relay1.vsu.ru ([62.76.169.14]:62108 "EHLO relay1.vsu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbZJXWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 18:24:14 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Oct 2009 18:24:13 EDT
X-drweb-hash: 
Date: Sat, 24 Oct 2009 22:09:06 +0100 (BST)
From: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
X-X-Sender: tigran@ginsburg.homenet
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
In-Reply-To: <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> 
 <20091023233756.941535000@alcatraz.americas.sgi.com>
 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810303-1689420186-1256418546=:2439"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810303-1689420186-1256418546=:2439
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>> - =A0 =A0 =A0 printk(KERN_INFO "microcode: CPU%d sig=3D0x%x, pf=3D0x%x, =
revision=3D0x%x\n",
>> + =A0 =A0 =A0 if (cpu_num < 4 || !limit_console_output(false))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_INFO
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "microcode: CPU%d sig=3D0x=
%x, pf=3D0x%x, revision=3D0x%x\n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_num, csig->sig, csig-=
>pf, csig->rev);
>>
>
> Hmm, I guess we wouldn't lose a lot by simply removing those messages
> completely. Per-cpu pf/revision is available via /sys anyway.

The reason for printing them is that the pf (possibly others?) can change=
=20
by the update and so the log has this info handy.

Kind regards
Tigran
---1463810303-1689420186-1256418546=:2439--
