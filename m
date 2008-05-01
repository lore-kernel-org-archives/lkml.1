Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYEACNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYEACNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYEACM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:12:59 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:22980 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753989AbYEACM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:12:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J6nFWDW5BreEYON/HRhFwTFWRZeH5EUk6/VJ+mvVyTs0cKTxTLMSQxgB8ihlm8xL/rD7KJQhl1x8+fFId9Mj+xBU5738L9kYY6j03VonrdW+b1kqhfpZXY5ASD3la/e+1xeZPwX316lc4yYJCiB7007rGvs3+QnLThIuiiV37Z8=  ;
X-YMail-OSG: aF7rl_4VM1lzzFErgJi2MdG_IwSwW4ZW55o5.UttMEjvtLc0htz9NvUkrorgqk9oidMnW7A8EbjFSTtxZ1fasrycEyCR9Ajzgm9gtlLk2M_y3diSoeqBuZZ_13ZYjo9Xvws-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Wed, 30 Apr 2008 19:12:55 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <Pine.LNX.4.64.0804301511120.1537@t2.domain.actdsltmp> <1209597298.3377.20.camel@moss.renham>
In-Reply-To: <1209597298.3377.20.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804301912.55677.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	 This is
> > very helpful for people connecting something to the interface to know they
> > have the write gpio lines connected.  What's the point of allowing
> > one to label gpio lines if it's not going to be easy to see?
> 
> That label was always just supposed to be a debugging aid, i.e.
> something to show up in debugfs.  This is used to reduce D footprint.
> Maybe if the labels are being stored anyway they can be made available
> through sysfs as well as debugfs?

They could be; I've had code to do it.  It never stays in
very long, because for a pure userspace interace it can't
be helpful unless userspace makes the labels:  the labels
displayed otherwise just reuse the same constant.

For a "kernel cooperates with userspace" model that might
be more useful.  And I've certainly found the debugfs info
hard to interpret without such labels!!  But Trent has
said he doesn't see anyone modifying enough code to adopt
such a "cooperates" model.  Which is why this particular
side-argument seems like a waste of time to me:  even he
has not proposed the key change his argument depends on.


The original control file syntax I thought about was

	export NN mode label

where it would gpio_request(NN, "label") and then set the
direction (and maybe value) according to "mode".  But that
was just a PITA to cope with ... so it's now been trimmed
down to just "NN" (and "-NN").

- Dave

