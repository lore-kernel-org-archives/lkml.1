Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbXISW4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbXISW4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXISW4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:56:00 -0400
Received: from web53701.mail.re2.yahoo.com ([206.190.37.22]:46703 "HELO
	web53701.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752921AbXISWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:55:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FDB6imZdVJGfyG8vtoV0D/rsG6qoDGDaZlq2TQXGqaZNpUwdV2VKh6buMmJs/n27b2kOYU0iZdGqDfQNQX+/4H8dg96cql4M9gpjErtk6yDMic+zEPBCpun7aJnA7EqTAunQQfEqWPxPJ8PfeEOfDqIusLifHVwg2A/Ve3PyeY8=;
X-YMail-OSG: W5iBIH0VM1liT7VeUa2g6TmLNCyHgPX08ACoy14YNYFBvmoOp4aMhOCIykBLxlraiiTEcm_0py96e3qDmbIHguvm8R9VQNgIUEoaMndPWimZpsokkto-
Date: Wed, 19 Sep 2007 15:55:58 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23-rc6 Resending] NETWORKING : Edge Triggered EPOLLOUT events get missed for TCP sockets
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
In-Reply-To: <20070919.154402.34760338.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <640879.56443.qm@web53701.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Miller <davem@davemloft.net> wrote:

> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> Date: Wed, 19 Sep 2007 15:37:09 -0700 (PDT)
> 
> > With the SOCK_NOSPACE check in tcp_check_space(), this epoll_wait call will 
> > not return, even when the incoming acks free the buffers.
> >         Note that this patch assumes that the SOCK_NOSPACE check in
> > tcp_check_space is a trivial optimization which can be safely removed.
> 
> I already replied to your patch posting explaining that whatever is
> not setting SOCK_NOSPACE should be fixed instead.
> 
> Please address that, thanks.

Dave, 
     I agree that setting SOCK_NOSPACE would have been a more elegant
fix. Infact I thought a lot about that before deciding on this fix.
    But the point here is that the SOCK_NOSPACE bit can be set when 
the sndbuf space is really less (less than sk_stream_min_wspace())
and some user action (sendmsg or poll) indicated his intent to write.
    In the case mentioned none of these is true. Since user wants
to manage his tranmit buffers himself, his definition of less may
not match with what kernel feels is less. f.e. user might have 
dynamically changing mmap'ed buffer resources at his disposal 
which he wants to use as sendfile buffers. He wants to be notified
whenever a new incoming ack frees up one or more of his buffers,
so that he can reuse that buffer.
    The bigger problem is that user is not indicating his intent
to write, to the kernel. He is just watching the sendbuf space and
when it matches his needs he will send new data. 

Thanx,
Tomar

 



      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
