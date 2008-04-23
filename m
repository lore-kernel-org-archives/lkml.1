Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYDWI2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYDWI2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYDWI1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:27:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:4911 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYDWI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pWC4u7wA2Sxsy/SvW7qKNPY7RwibLaV5csmyPkzbu2b/vejo5XA7WBewwG3+XYSzPBV70eo1x7seoipobtirJjdkhCV5ocbhUMq3dBTbfYxfaHI/EEYhdsahBzTN8b0p+BT2WCQqO4UFl51VkGng3jncUaPRBvCmhoiL1621K80=
Message-ID: <cfd9edbf0804230127k33a56312i6582f926e00ea17@mail.gmail.com>
Date: Wed, 23 Apr 2008 10:27:46 +0200
From: "=?ISO-8859-1?Q?Daniel_Sp=E5ng?=" <daniel.spang@gmail.com>
To: "Tom May" <tom@tommay.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ab3f9b940804171223m722912bfy291a2c6d9d40b24a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080402154910.9588.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940804141716x755787f5h8e0122c394922a83@mail.gmail.com>
	 <20080417182121.A8CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940804171223m722912bfy291a2c6d9d40b24a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom

On 4/17/08, Tom May <tom@tommay.com> wrote:
>
>  Here is the start and end of the output from the test program.  At
>  each /dev/mem_notify notification Cached decreases, then eventually
>  Mapped decreases as well, which means the amount of time the program
>  has to free memory gets smaller and smaller.  Finally the oom killer
>  is invoked because the program can't react quickly enough to free
>  memory, even though it can free at a faster rate than it can use
>  memory.  My test is slow to free because it calls nanosleep, but this
>  is just a simulation of my actual program that has to perform garbage
>  collection before it can free memory.

I have also seen this behaviour in my static tests with low mem
notification on swapless systems. It is a problem with small programs
(typically static test programs) where the text segment is only a few
pages. I have not seen this behaviour in larger programs which use a
larger working set. As long as the system working set is bigger than
the amount of memory that needs to be allocated, between every
notification reaction opportunity, it seems to be ok.

/Daniel
