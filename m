Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbXHRBEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbXHRBEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 21:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbXHRBDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 21:03:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32878 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbXHRBDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 21:03:53 -0400
Date: Fri, 17 Aug 2007 18:03:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Satyam Sharma <satyam@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <1187394022.7007.133.camel@chaos>
Message-ID: <Pine.LNX.4.64.0708171758520.15278@schroedinger.engr.sgi.com>
References: <46C233CB.9000602@am.sony.com>  <1187132149.2618.2.camel@laptopd505.fenrus.org>
  <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in> 
 <20070817112253.e6a7cb33.akpm@linux-foundation.org> 
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com> 
 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
 <1187394022.7007.133.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Thomas Gleixner wrote:

> If yes, who invented this 1980s reminiscence, where you got valid
> pointers for malloc(0) ?

I believe his first name started with an L and ended with an s ;-)

Seriously the kmalloc(0) pointer allowed us to detect cases in which 
people tried to store into objects allocated with kmalloc(0).

If we would just return NULL then we would not be able to distinguish it 
from a failure (that is what I initially had).

