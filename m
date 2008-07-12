Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYGLIhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYGLIhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 04:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYGLIhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 04:37:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:7134 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYGLIhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 04:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=niMVlOWb0QErVYgHHwW1cUtLvQ236Q/JD8fXQ21Bx/g8gaLBO5aaTi7R7ebC+qBi9H
         slnj8OOoKsWiGgMeGu3eSfyDaML4Y/SN2rRgvrRDxUkGbXu6J/poE6ul6cABF/YID7KR
         C/9BH2D1heGfbUyXlyXvOWVzP9jw0kdJ5zsX4=
Message-ID: <86802c440807120137l186864a3s5046ecbee6c63531@mail.gmail.com>
Date: Sat, 12 Jul 2008 01:37:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
In-Reply-To: <m1tzev1pyy.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710181634.764954000@linux-os.sc.intel.com>
	 <20080711204521.GA15689@elte.hu>
	 <20080711212418.GV1678@linux-os.sc.intel.com>
	 <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
	 <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
	 <m163rb4v3j.fsf@frodo.ebiederm.org>
	 <86802c440807112317h23118e29j51113a052720d8db@mail.gmail.com>
	 <m1y7471t5t.fsf@frodo.ebiederm.org>
	 <86802c440807120049t2aaec131l4c735712f2befb2@mail.gmail.com>
	 <m1tzev1pyy.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 1:11 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>>>> also read the x2APIC spec pdf, it doesn't say anything about interrupt
>>>> remapping...need to be used with x2apic...
>>>
>>> Clustered logical mode won't work as it requires > 16 bits of apicid.
>>> So only flat physical mode will work.
>>
>> current read_apic_id in genx2apic_cluster and genx2apic_phys is the same...
>
> There is a fixed defined mapping between logical & physical mappings,
> so that may not be an issue.
>
> A logical cluster apicid is encoded with the high 16bits being the
> cluster number, and the low 16bits being a bitmap of which core
> in the cluster to send the irq to.  It sounded like a single
> cluster can not span multiple sockets.
>
> So in practice if you have 2 sockets you have a cluster id of 1.
> Which means physical apic ids over 16 and logical apicids over 65536.
is it like
0x0001, 0x0002, 0x0004, 0x0008, ...., 0x8000 in one cluster? so every
cluster only have 16

YH
