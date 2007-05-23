Return-Path: <linux-kernel-owner+w=401wt.eu-S1764190AbXEWSBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764190AbXEWSBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbXEWSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:00:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:17188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbXEWSAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lTC52agOT04xeDNcpuj6hRVdA0DK6xOqzk1paha7uGv0rbLwZ5ru4nYQ0RyFPDSY4NZ+/FZ4ChX073SFfuF8VlnvdzF2jPOXn5MEwb6LYnPgSC8UQq5x3USoubssgYmuLWj838UYOwF08GB1WIR/5Cg/HnGOZPHCX4iAQqEQzaM=
Message-ID: <a781481a0705231100q333a589at6c025eb1292019cd@mail.gmail.com>
Date: Wed, 23 May 2007 23:30:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrea Righi" <righiandr@users.sourceforge.net>,
       "Andi Kleen" <ak@suse.de>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>, "Rik van Riel" <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <20070521124734.GB14802@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464C9D82.60105@redhat.com>
	 <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
	 <20070520205500.GJ22452@vanheusden.com>
	 <200705202314.57758.ak@suse.de>
	 <46517817.1080208@users.sourceforge.net>
	 <20070521110406.GA14802@vanheusden.com>
	 <Pine.LNX.4.61.0705211420100.4452@yvahk01.tjqt.qr>
	 <20070521124734.GB14802@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> > >What about the following enhancement: I check with sig_fatal if it would
> > >kill the process and only then emit a message. So when an application
> > >takes care itself of handling it nothing is printed.
> > >+    /* emit some logging for unhandled signals
> > >+     */
> > >+    if (sig_fatal(t, sig))
> > Not unhandled_signal()?
>
> Can we already use that one in send_signal? As the signal needs to be
> send first I think before we know if it was handled or not? sig_fatal
> checks if the handler is set to default - which is it is not taken care
> of.
>
> > >+    {
> > if (sig_fatal(t, sig)) {
> > >+            printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
> > s/send/sent/;
> > >+            sig, t -> pid, t -> uid, t -> gid, t -> comm);
> > t->pid, t->uid, t->gid, t->comm);
>
>
> Description:
> This patch adds code to the signal-sender making it log a message when
> an unhandled fatal signal will be delivered.

Gargh ... why does this want to be in the *kernel*'s logs? In any case, can
you please make this KERN_INFO (or lower) instead of KERN_WARNING.
