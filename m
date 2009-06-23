Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZFWNcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZFWNcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZFWNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:32:32 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:22938 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZFWNcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Vq+yjDrLBn+dHNCiJNoDUA6k+Hs44FA8TEh4vcf3c437nzQyGVuAXRpxTum+l43Az8
         8XtcD5Sur66GwKr0r5pNGFxLElJJSolVV3USEb3VAT021y/yVLOg9pjhakO4H7TgpTI4
         yu4JNz2/7+wbVcLNMdUTKTfh4x5Ec0BhVhpvQ=
MIME-Version: 1.0
In-Reply-To: <1245757970.19816.1675.camel@twins>
References: <fc71709d0906230117h2bee4d7en9f3aadeae3cb9545@mail.gmail.com>
	 <fc71709d0906230202w14da8ffdpf457f7a6ed658a28@mail.gmail.com>
	 <1245753219.19816.1586.camel@twins>
	 <fc71709d0906230443pf8c4b34pcd4b7fa798fbf1ed@mail.gmail.com>
	 <1245757970.19816.1675.camel@twins>
Date: Tue, 23 Jun 2009 21:32:33 +0800
Message-ID: <fc71709d0906230632qefb072bj5ea7597b20972aa3@mail.gmail.com>
Subject: Re: mm: dirty page problem
From: xue yong <ultraice.kernel@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 7:52 PM, Peter Zijlstra<peterz@infradead.org> wrote:
> On Tue, 2009-06-23 at 19:43 +0800, xue yong wrote:
>> Thanks a lot, Peter.
>> Your reply resolved my doubt.
>>
>> we have a service program (just say A) running with about 14G mmaped data.
>> and there is another daemon (just say B) do msync( SYNC) periodically.
>>
>> so I want to know in this pattern, was the data flushed to disk?
>
> I don't think so.
>
> The problem is that msync() only scans the current process' page tables,
> which would be clean since B doesn't write, only A does.
>
> So you'd have to modify your program, A, to do the msync() itself --
> possibly from a thread (threads share the vm context and thus page
> tables).
>


:)  I did have this thought, because there was littile bo(block out),
and pmap showed that
the dirty pages belong to a process was always growing.

I believe you are the authority. Your confirmation matters.

In "Understanding the Linux® Virtual Memory Manager" page 163, Mel
Gorman said that
Process-mapped pages are not easily swappable because there is no
way to map struct pages to PTEs except to search every page table, which is far
too expensive.
So  neither kswapd nor other kernel daemons do the scan job.
Without explicit action these pages would stay hidden.



>> and we have the problem,  after we stoped/restarted  A,  many ditry
>> pages emerged,
>> about 4G data was flushed out in the following time.
>>
>> Thanks for your advice on these patches. I understand it now.
>> So if we change the kernel to a higher version, can we solve the
>> problem I mentioned above.
>
> Yes, I would recommend running a more recent kernel.
>
