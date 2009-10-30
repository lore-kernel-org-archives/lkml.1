Return-Path: <linux-kernel-owner+w=401wt.eu-S932567AbZJ3QNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbZJ3QNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbZJ3QNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:13:16 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62734 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522AbZJ3QNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gJYixZHacQ0o0XVBC2+1iVc3F30WuRRItbnON8wfy9DKUXZdRh9H3Yxb15WcyPCDeR
         UNB+7vG0TWOYxkbsevvlW4doD8ePQlkY0L4JNqx7V5yB0odK0In+NWe/kJfFhiwzoM9P
         T3v73X/Zycp5nU4cQcqcGZ2KVR2yYUxfyJVug=
Message-ID: <4AEB109A.7090506@gmail.com>
Date: Fri, 30 Oct 2009 12:13:14 -0400
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: apetlund@simula.no,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       Christian Samsel <christian.samsel@rwth-aachen.de>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
References: <52481f5b4edfdbd96dcde46aed403fcf.squirrel@webmail.uio.no>
In-Reply-To: <52481f5b4edfdbd96dcde46aed403fcf.squirrel@webmail.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apetlund@simula.no wrote:
> I share the opinion that the linear timeouts should be limited, and back
> off exponentially after the limit, as Eric suggested. I believe this will
> be a sufficient safety-valve for the black-hole scenario, although I would
> like to run some tests.
> 
> As I wrote to Arnd, there are many similarities with the EFR approach and
> what our patch does. The largest difference is that the thin-stream
> patterns are identified as an indication of time dependent/interactive
> apps. This is the reason why the proposed patch does not try to keep an
> inflated cwnd open, but only focuses on the cases of few packets in
> flight. The target is time-dependent/interactive applications, and as such
> we don't want a generally enabled mechanism, but want to give the option
> of enabling it only in the cases where they are most needed (in contrast
> to a generally enabled "automagically" triggered EFR).
> 
> Below is a link to a table presenting some of the applications that we
> have traced and analysed the packet interarrival times of:
> 
> http://folk.uio.no/apetlund/lktmp/thin_apps_table.pdf
> 
> We were surprised to see how many cases of "thin-stream" traffic patterns
> were indicative of time-dependent/interactive apps.
> 
I'm finding it hard to follow 3 threads, for the 3 parts of the patch.

As I mentioned in one of these threads, I've plenty of experience with
designing and implementing protocols for gaming.  And it seems to me that
you're making changes to the entire TCP stack to make up for shortcomings
in the implementor's design.  Yet, these changes require application
implementors to set a sockopt that's only available in Linux.  Unlikely,
as they probably don't even keep track of such things....

There are other efforts in this area, they've been mentioned.

I'm new to this list, so I'm not entirely sure that protocol design is
regularly discussed here.  But I'd prefer that the discussion moved to
one of the lists that's dedicated to such protocol design and testing.

I've already suggested the end-to-end interest list, where you'll find many
of us with a strong interest in this topic.

List-Subscribe: <http://mailman.postel.org/mailman/listinfo/end2end-interest>,
	<mailto:end2end-interest-request@postel.org?subject=subscribe>

The IETF has two related working groups:
   tcpm -- tcp modifications
   tsvwg -- general transport, including sctp modifications

Without further ado, just count me as opposed at this time.
