Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZCVTEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZCVTEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZCVTEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:04:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48668 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZCVTEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:04:23 -0400
Date: Sun, 22 Mar 2009 20:06:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
Message-ID: <20090322190622.GA5362@uranus.ravnborg.org>
References: <1237667676.17548.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237667676.17548.3.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 02:04:36AM +0530, Jaswinder Singh Rajput wrote:
> Hello Sam, Ingo:
> 
> On latest -tip I am getting following warnings:
> 
>   LD      arch/x86/pci/built-in.o
> make[1]: warning:  Clock skew detected.  Your build may be incomplete.
> make[1]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
>   CC      arch/x86/power/cpu_64.o
>   LD      arch/x86/power/built-in.o
> make[1]: warning:  Clock skew detected.  Your build may be incomplete.
> make[1]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
>   CC      net/socket.o
> make[2]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
> make[2]: warning:  Clock skew detected.  Your build may be incomplete.
> make[2]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
>   CC      net/core/sock.o
> 
> [jaswinder@hpdv5 linux-2.6-tip]$ ls -l include/config/auto.conf
> -rw-rw-r-- 1 jaswinder jaswinder 18788 2009-03-22 07:14 include/config/auto.conf
> 
> [jaswinder@hpdv5 linux-2.6-tip]$ date
> Sun Mar 22 02:02:44 IST 2009
> [jaswinder@hpdv5 linux-2.6-tip]$ 

I have checked the source code in kconfig where we minupulate auto.conf.
We do a simple 

fopen(".tmpconfig", "w");
write a lot
fclose()
rename(".tmpconfig", "auto.conf");

So nothing suspicious that involves changing the date of the file.

I expect you have to locate the issue locally if it happens again.

I wonder if we save filetime in UTC or in local time.
If it is the latter then if logged in as different users
with different timezone could maybe explain it.

You are UTC+5,5 hours in IST IIRC and the clock skew is 5,2 hours.

[And it was late in night too :-) ]

	Sam
