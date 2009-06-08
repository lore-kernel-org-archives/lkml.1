Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZFHPXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZFHPXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZFHPWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:22:53 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43442 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZFHPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EwH/BteopsocnR9tO96/J6dvUe6uV6qMDG0Kh8iIjhVkkFpbFfcvrSmMWLFRaBlbVf
         ktXuphckEP3OJrR55FXoVvdEqJCxsLBrBux0faqxQrhlInTGeNib8A8h567IADMrZaj5
         ToGwB23pcuMiYEm1+H5wJuOMi4iEdmdvhWiyU=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906071617010.27806@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
	 <661de9470906070712y7b90d1bbn60b110bdb99a0d01@mail.gmail.com>
	 <alpine.DEB.2.00.0906071617010.27806@chino.kir.corp.google.com>
Date: Tue, 9 Jun 2009 00:21:28 +0900
Message-ID: <28c262360906080821v542bc573r496209402779d5c2@mail.gmail.com>
Subject: Re: [patch -mmotm] oom: only oom kill exiting tasks with attached 
	memory
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David.

On Mon, Jun 8, 2009 at 8:18 AM, David Rientjes<rientjes@google.com> wrote:
> On Sun, 7 Jun 2009, Balbir Singh wrote:
>
>> Seems like a good change to make. Did you encounter this situation on
>> a real machine?
>>
>
> I did, as the result of the chosen task remaining in PF_EXITING state with
> a detached mm following a previous oom kill.
> --

Let me have a question.
If I understand your situation properly, you mean

Time order
t1 < t2 < t3 < t4.

t1 : oom kill A process - send signal. it doesn't destroy mm_struct yet.
t2 : destroy A's mm_struct but it is in task list.
t3 : It happens OOM, again. Process A is selected again since it still
remain in task list
t4 : Now A's mm_struct is destroyed => situation you said.

Is right ?
Do you turn on sysctl oom_kill_allocating_task ?

-- 
Kinds regards,
Minchan Kim
