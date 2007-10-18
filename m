Return-Path: <linux-kernel-owner+w=401wt.eu-S934913AbXJRXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913AbXJRXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762329AbXJRXxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:53:08 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:20166 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753339AbXJRXxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:53:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K/MkTrqe0zUuuNHiOqZI79l/zjwnqFdTziZXRw8c7WX/M/hhzkOcrbYUzzOF5ztlE2icB5PU79GrxbTlZd2CaP4RYyATaPOrS6WSCRTrF0AgNcpk8TAjebu24+k1SeePR4NjS+n4JdKcFz+aHZg6VIhAh9JD7oveoyK3jtNLN94=  ;
X-YMail-OSG: wFx8C1IVM1nbqiP8HGEnVl5yFeKmdELKU3g37Q8MfXRZgrrzDZZ_RZgg3ZWmRpYk1hEQ9x7PAXqPKkX9A1vmjYwDmXgMZ9FXJmzhRz9M6X0X.vHgnf0-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Richard Jelinek <rj@petamem.com>
Subject: Re: kswapd0 inefficient?
Date: Fri, 19 Oct 2007 09:52:38 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071018220510.GA22288@petamem.com>
In-Reply-To: <20071018220510.GA22288@petamem.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710190952.38553.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 08:05, Richard Jelinek wrote:
> Hello guys,
>
> I'm not subscribed to this list, so if you find this question valid
> enough to answer it, please cc me. Thanks.
>
> This is what the top-output looks like on my machine after having
> copied about 550GB of data from a twofish256 crypted disk to a raid
> array:
> --------------
> Mem:   8178452k total,  8132180k used,    46272k free,  2743480k buffers
> Swap:        0k total,        0k used,        0k free,  4563032k cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  5954 root       0 -20     0    0    0 R   62  0.0  96:42.61 loop0
>  6014 root      18   0 23744  19m  484 R   20  0.2  25:45.31 cp
>   255 root      10  -5     0    0    0 S    8  0.0  10:21.82 kswapd0
>  6011 root      10  -5     0    0    0 D    6  0.0   4:15.66 kjournald
> ...yadda yadda...
> --------------
>
> And what do we see here? We see loop0 and cp eating up some
> time. That's ok for me considered the work they do. kjournald is also
> ok for me, but I ask myself: why the heck has kswapd0 crunched 10+
> minutes of CPU time?
>
> I mean what does kswapd0 do?
> http://www.linuxforums.org/forum/linux-kernel/65380-what-does-kswapd0-do.ht
>ml
>
> And I have no swap - right? So it should just shut up - IMHO. Or am I
> missing something?

kswapd also reclaims pagecache, not just anonymous memory. It runs
in response to memory pressure and if it wasn't around, then all
your apps requesting memory would have to do basically the same
amount of work themselves.
