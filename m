Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXHZPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXHZPcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXHZPcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:32:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:63189 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbXHZPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Rygkkd41bbzFTCAWF6GMyKRXkUafNe2n3+pS9hlSlN1KrKWw9VHnSp/OlNRUMbJsPnNyeShHk4amTkUiMqNwOXsIxcX6LkVVxFrCLZbmJoRWDPGY/mlj3GDi6mlDbxJVkSSrdphWKk+nKbp4JzbpuNh1KO9R3+V6SGZa3crfJpA=
Date: Sun, 26 Aug 2007 19:32:01 +0400
To: Fred Tyler <fredty8@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
Message-ID: <20070826153201.GA1776@martell.zuzino.mipt.ru>
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2007 at 10:39:11AM -0400, Fred Tyler wrote:
> I think I've come across a memory leak in 2.6.20. I've upgraded to the
> latest 2.6.20.17, but it didn't seem to help.
> 
> A little background: I saw something exactly like this many months ago
> with a 2.6.12 kernel. However, by 2.6.16.x the leak had apparently
> been fixed, so I didn't pursue it. I just assumed it had been fixed.
> But either it remains in 2.6.20 or else a new leak has appeared.
> 
> FWIW, this is an x86_64 machine, but I also saw nearly the same
> behavior on a i386 machine running 2.6.12. (Links to graphs showing
> long-term memory usage are at the bottom of this email if you want to
> skip all the text stats in the middle.)
> 
> Immediately after booting the system, I shut down all services to get
> a baseline for comparison. Here is the output of top and vmstat with
> virtually nothing running:

You can try "Kernel Hacking" => "Debug slab memory allocations" =>
"Memory leak debugging". After you think it leaked pretty much, post
output of

	sort -n -k2 /proc/slab_allocators
