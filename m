Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbZG2Pwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbZG2Pwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZG2Pwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:52:33 -0400
Received: from fifo99.com ([67.223.236.141]:33261 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbZG2Pwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:52:32 -0400
Subject: Re: [RFC][patch 02/12] remove clocksource inline functions
From: Daniel Walker <dwalker@fifo99.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <20090729173231.012d0b89@skybase>
References: <200907291457.n6TEvDAt003701@d06av06.portsmouth.uk.ibm.com>
	 <20090729173231.012d0b89@skybase>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 08:52:50 -0700
Message-Id: <1248882770.28841.236.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 17:32 +0200, Martin Schwidefsky wrote:
> Hmm, you have an object of type struct clocksource and you do
> cs->read(cs). If that is not clear enough then I don't know what is.

It's not as clear as it could be .. In the case above you have to look
in at least two places to know what's going on.. First to see the
cs->read() , and second to see if "cs" is actually a clocksource or
something else.. "cs" could be declared anyplace with any name.

If you see clocksource_read(cs) , you might need to once check what
clocksource_read() is actually doing, but only once.. After that when
you see that function you know that variable is a clocksource, and it's
"read()" is getting called. So you only need to review one line in the
simplest case.

Daniel

