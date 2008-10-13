Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYJMQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYJMQqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYJMQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:46:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52242 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbYJMQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:46:06 -0400
Date: Mon, 13 Oct 2008 11:46:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Chris Friesen <cfriesen@nortel.com>, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect
	checkpoint/restart to work
Message-ID: <20081013164559.GA31636@us.ibm.com>
References: <20081009190405.13A253CB@kernel> <1223626834.8787.8.camel@localhost.localdomain> <48EF144D.1050906@fr.ibm.com> <20081010145934.GF11695@elte.hu> <48EF7211.2000303@cs.columbia.edu> <1223656489.10017.33.camel@localhost.localdomain> <48EF8E77.8050000@nortel.com> <1223885897.4404.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223885897.4404.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kurz (gkurz@fr.ibm.com):
> On Fri, 2008-10-10 at 11:18 -0600, Chris Friesen wrote:
> > Greg Kurz wrote:
> > 
> > > This flag is weak... testing it gives absolutly no hint whether the
> > > checkpoint may succeed or not. As it is designed now, a user can only be
> > > aware that checkpoint is *forever* denied. I agree that it's only useful
> > > as a "flexible CR todo list".
> > 
> > I don't think it's true that it gives "absolutly no hint".
> > 
> > If the flag is not set, then checkpoint will succeed, right?  Whereas if 
> 
> Wrong. Unless you test_and_checkpoint atomically, the flag doesn't help.

Atomically wrt what?  Presumably you test and checkpoint while the
container is frozen...

> > the flag is set, then it's an indication that checkpoint could fail (but 
> > may still succeed if whatever condition caused the flag to be set is no 
> > longer true).
> > 
> > Chris
> > 
> -- 
> Gregory Kurz                                     gkurz@fr.ibm.com
> Software Engineer @ IBM/Meiosys                  http://www.ibm.com
> Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420
> 
> "Anarchy is about taking complete responsibility for yourself."
>         Alan Moore.
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
