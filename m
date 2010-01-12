Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554Ab0ALR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0ALR7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158Ab0ALR7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:59:43 -0500
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:29617 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753840Ab0ALR7m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:59:42 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 12:59:42 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FmYbvY+yKR6jOwIb0sHbS8Iia9njtl2RHiAw2pfaY9V6PF3s9rz79+TKzDiAjLn+d/9Ak8PbmNeoGBTk19lyOYiyjZqa4aGR7f/diElsho8HVxZKOkDIG/PlkFibEch/xluesVqAm/Reg7E+UM9o1NvtsdUbPd0DPxjUl55LYwY=;
Message-ID: <556048.68282.qm@web82105.mail.mud.yahoo.com>
X-YMail-OSG: 2IjHaEEVM1lbHBAHqppW54KHrrpXXwfjj8eu6xXkxeOyDpqZqgZWfq8ab9FvvilmqHFD7f9CjDgfMeSF6HBWPiAgox543356u_MqJKTxd6HQikMiR9plipojySm1zBaocg5nXC3oQuUzSQRHs6illEmUVg5Gt7Dr9RZPVIxBQwoH5fBgplHirlsa4NGu5_D.PM_YXkuU9mKxgTs1xR4.IuTbAF7owQhCcVUsqKpLgtKkTxoxq21RBvxO_unRP1XjKKggyCAWAMC9XV4d2mtH9ZF0u.o0qT8et9g_H6t8V9_CSZrzENfM4G8_r6a40IRueou2ZiCPgF6oO1GNmj1uO3PQtp7ik7A773bOkA--
X-Mailer: YahooMailRC/240.3 YahooMailWebService/0.8.100.260964
References: <4B4C3E4F.9060001@memeplex.com> <20100112145213.GB3925@hack>  <1263308127.4244.142.camel@laptop> <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com>
Date: Tue, 12 Jan 2010 09:53:01 -0800 (PST)
From: Gong Cheng <chengg11@yahoo.com>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Athan <linux_kernel_aathan@memeplex.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
    It has been a little while when we were hit by the problem, and from then I didn't touch that area, so forgive me if I can not answer all your questions.
    Basically after switching from 2.6.31.1 and 2.6.31.4, the problem seems to have gone away. 
    It was very reproducible for us in 2.6.31.1 (if coupled with glibc 2.5.34.1 or any version around. I believe as long as it was after the private futex work in glibc).  
After the switch, we might have had another similar occurrence but it was not clear if was the same problem. Since it didn't occur again, we let it go. 
   now we are in 2.6.32.1, and it is still running fine. So the problem is either completely gone with the newer kernels. Or it is just much less likely to happen.
That is pretty much all I can provide, and hope it helps.

-gong




----- Original Message ----
From: Américo Wang <xiyou.wangcong@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Athan <linux_kernel_aathan@memeplex.com>; linux-kernel@vger.kernel.org; Darren Hart <dvhltc@us.ibm.com>; Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@elte.hu>; Gong Cheng <chengg11@yahoo.com>
Sent: Tue, January 12, 2010 7:00:57 AM
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64

On Tue, Jan 12, 2010 at 10:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-01-12 at 22:52 +0800, Américo Wang wrote:
>
>> > $ uname -a
>> > Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64
>> > GNU/Linux
>
> Does a recent kernel work?
>
>

Ah, I just wanted to ask the same question, adding the original reporter
Gong Cheng into Cc...

Gong, could you reproduce it on the latest kernel? And what is your .config?

Thanks!

