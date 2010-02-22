Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0BVNgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:36:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:26263 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0BVNgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qr7RBuVnjFMSciMdckv15e8j4Ri9Pf3QBFcN9WzphfFWXmdPvxiu4zYhM3o94wInEI
         8sQvCZICVWmBGH8S70yd08vu5t4vlhuCDhUccz/6AHP1r73O2JU6MyhB4axgBJeG4R+I
         sO4VmsKZU7kkX02V1LUvWXJ+yASZj7YpqZlps=
Date: Mon, 22 Feb 2010 16:36:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
Message-ID: <20100222133629.GD5416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	rt-users <linux-rt-users@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
	Clark Williams <williams@redhat.com>,
	Frank Rowand <frank.rowand@am.sony.com>,
	Robin Gareus <robin@gareus.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Philippe Reynes <philippe.reynes@isismpp.fr>,
	Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
	Will Schmidt <will_schmidt@vnet.ibm.com>,
	Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
	Sven-Thorsten Dietrich <sdietrich@novell.com>,
	Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
	John Kacur <jkacur@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>
References: <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain> <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/slab.c
  2117                  kmem_freepages(cachep, addr, *this_cpu);
  2118                  if (OFF_SLAB(cachep)) {
  2119                          if (this_cpu)

	We already dereferenced "this_cpu" two lines earlier. 

  2120                                  __cache_free(cachep->slabp_cache, slabp, this_cpu);
  2121                          else
  2122                                  kmem_cache_free(cachep->slabp_cache, slabp);

regards,
dan carpenter
