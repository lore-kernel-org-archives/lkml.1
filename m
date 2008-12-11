Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbYLKFmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbYLKFmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 00:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYLKFma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 00:42:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:35670 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYLKFm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 00:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lj/oF5L1k+i1bkUL+BWrAA/5XGTENZchl2CHSynJbPQIx3nX8O/HP3gMTLPWU9vAHj
         B5+n1VQp33pgEdNDONjy5Kqg2NiO12uM39PCVc1qYMzYo2SrmyU/LQgm3c/4QOinYrNw
         bN6h5QvFB4gmoFbUI/g4XOWkn64jw4jBCwnD0=
Message-ID: <9cde8bff0812102142s5d58b8dcibe5d36a68e09f367@mail.gmail.com>
Date: Thu, 11 Dec 2008 14:42:28 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix calls to request_module()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
In-Reply-To: <20081211050023.GM28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	 <20081211040118.GK28946@ZenIV.linux.org.uk>
	 <20081210201455.0c611484.akpm@linux-foundation.org>
	 <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
	 <20081211050023.GM28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 2:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 11, 2008 at 01:23:36PM +0900, Nguyen Anh Quynh wrote:
>
>> So I checked again by fixing the code that should be compiled
>> (sound/core/sound.c), and can confirm that without the patch we got
>> warning like below:
>>
>> sound/core/sound.c: In function 'snd_request_other':
>> sound/core/sound.c:91: warning: format not a string literal and no
>> format arguments
>
> Ah, but that's different.  Take a look at that warning and think _why_
> it is given and what is it about.  Getting an untrusted string as
> format argument is a real security hole, but it has nothing to do
> with a pile of cases in your patch.

Yes, clearly the warning is to warn us about potential format string
bugs. But I agree that there are a lot of false possitives.

My patch is mainly to make gcc happy.

Thanks,
Q
