Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbYDNUBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbYDNUBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbYDNUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:01:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:37784 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760443AbYDNUBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AHk2gceFqBnt0kWP2ij9RuNjabpyu8GPKpksX80xTPI2Gc9emSCOWxVzAHUy5sSP7ka4UwQ1QTcOrmgNuPQeM1XsInpRWTQneBkwMM2S1C0HF/wxUFRanMfTzdQDSv9Ddvoss60IejR962CMEsjRgOgDPx3rJoCuNv/+I3ExuLY=
Message-ID: <4a4634330804141301l69d29e32wefa1ceb4ec75ec57@mail.gmail.com>
Date: Mon, 14 Apr 2008 15:01:38 -0500
From: "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: valid task structure and wake_up_process
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080414121105.5f9e5482@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4a4634330804141136xcaf098esf02539bf76917781@mail.gmail.com>
	 <20080414121105.5f9e5482@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/08, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 14 Apr 2008 13:36:42 -0500
> "Shirish Pargaonkar" <shirishpargaonkar@gmail.com> wrote:
>
> > How do I check whether a task is valid before calling
> > wake_up_process() with that task structure pointer?
>
> Hi,
>
> how did you get the pointer you got?
>
> That part (the guy who gave you the pointer) should have taken a reference on the task basically,
> or otherwise locked against the task going away.
>
> In giving you advice it would help tremendously if you actually posted your code...
>
>
>
>
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

Thanks.

This is cifs code fs/cifs.

In cifs_demultiplex_thread, in fs/cifs/connect.c, it calls wake_up_process in
a thread cifsd.

The task struct ptr is stored in mid as current when sending a request.  So this
could a command such as ls or some other application.
A request was sent but a reply was not received or reply was processed late
before the process went away and we have a probably freed task structure
being treated as valid in cifs_demultiplex_thread.

So I thought of checking validity of task structure before calling
wake_up_process.

Regards,

Shirish
