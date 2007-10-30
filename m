Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXJ3CBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXJ3CBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 22:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXJ3CBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 22:01:24 -0400
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:40403 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbXJ3CBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 22:01:23 -0400
X-Greylist: delayed 4539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 22:01:22 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] raise tsc clocksource rating
Date: Tue, 30 Oct 2007 00:45:01 -0000
Message-ID: <8A87A9A84C201449A0C56B728ACF491E34C5F5@liverpoolst.ad.cl.cam.ac.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] raise tsc clocksource rating
Thread-Index: AcgagpWZi0y6h18TQwu6bYWSPqCn1AACLVFw
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org> <20071029225528.GA31293@elte.hu> <47266A00.4040408@goop.org> <20071029232140.GA10518@elte.hu>
From: "Ian Pratt" <Ian.Pratt@cl.cam.ac.uk>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
       <rusty@rustcorp.com.au>, "Avi Kivity" <avi@qumranet.com>,
       <kvm-devel@lists.sourceforge.net>,
       "Glauber de Oliveira Costa" <glauber@t60.localdomain>,
       "Dan Hecht" <dhecht@vmware.com>, "Garrett Smith" <garrett@vmware.com>,
       <ian.pratt@cl.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sigh, I don't really want to have this fight again.
> 
> i dont remember us having discussed this before, ever. If there's any
> "fight" about monotonicity and SMP then it would be a pretty onesided
> affair, with you being beaten up seriously ;-)

Actually, it is possible, even for NUMA systems with CPUs running off
completely different oscillators, and in the presence of CPU frequency
changes, power management, and even in the presence of thermal
throttling (though the latter introduces temporary inaccuracies it
doesn't affect monotonicity or rate).

Take a look at the Xen code to see how each physical CPU is
independently calibrated on an ongoing basis, how movement of VCPUs
between physical CPUs is tracked, and how shared variables are used to
ensure montonicity if a guest requires it. 

The fixed-rate TSCs on newer CPUs make some of this stuff easier, but
you still need to cope with different source oscillators and some power
management states.
 
Ian

> > I don't really see what point there is in raising the tsc's rating
> > (why is 300 insufficient again?), but regardless of the value, the
Xen
> > clocksource rating needs to be higher.
> 
> anyway, i agree that this patch cannot go in in its current form.
> 
> 	Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
