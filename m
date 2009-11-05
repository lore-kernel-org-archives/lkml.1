Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZKETDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZKETDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbZKETDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:03:37 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58312 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbZKETDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:03:36 -0500
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
X-Mailer: Lotus Notes Release 7.0 HF242 April 21, 2006
From: Sean Foley <Sean_Foley@ca.ibm.com>
Message-ID: <OFFECD923E.35E1D650-ON85257665.00684B7F-85257665.0068AC54@ca.ibm.com>
Date: Thu, 5 Nov 2009 14:03:33 -0500
X-MIMETrack: Serialize by Router on D25ML01/25/M/IBM(Release 8.0.1|February 07, 2008) at
 11/05/2009 14:03:37,
	Serialize complete at 11/05/2009 14:03:37
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Foley
J9 Real-Time Java Ottawa Technical Lead
Sean_Foley@ca.ibm.com (613)356-5012

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote on 11/05/2009 
12:42:23 AM:

> > KOSAKI Motohiro wrote:
> > >> KOSAKI Motohiro wrote:
> > >>
> > >>> John, I'd prefer to suggested another design.
> > >>> How about this?
> > >>>
> > >>> 1. remove pid argument from prctl
> > >>> 2. cancel pthread_setname_np()
> > >>> 3. instead, create pthread_attr_setname_np()
> > >>> 4. pthread_create() change own thread name by pthread_attr.
> > >>>
> > >>> It avoid many racy problem automatically.
> > >> Perhaps, but it also greatly reduces the flexibility of the 
> > >> implementation by restricting name changes to create time.
> > > 
> > > Hm.
> > > if your program really need to change another thread name, can 
> you please tell us
> > > why it is necessary and when it is used?
> > 
> > I think John's previous mails covered that pretty well. As for doing 
the 
> > name change at create time, or sometime later, it just seems to me 
that 
> > the flexibility of doing so later is worth having. While I know we 
don't 
> > have to follow other systems implementations, in this case 
> > pthread_setname_np() seems a reasonable model to follow to me.
> 
> You only said your mode is more flexible. but I want to know _why_ 
> this flexibiliby is
> necessay. please tell us concrete use-case.
> 

Kosaki,
Here are a couple of use cases previously posted to this thread on the 
linux kernel mailing list:

dispatch thread adds context to thread names:
http://marc.info/?l=linux-kernel&m=125660141231348&w=2

java language support:
http://marc.info/?l=linux-kernel&m=125666430720863&w=2



Here are some various specific use cases from the web:

Attaching additional info to thread names when used for different 
purposes:
http://osdir.com/ml/java.jsr.166-concurrency/2006-12/msg00105.html

Threads obtained from thread pools being reassigned new names:
http://haacked.com/archive/2004/06/07/546.aspx
http://bytes.com/topic/c-sharp/answers/637152-naming-backgroundworker-thread

Renaming threads scattered across third-party libraries by enumerating 
them and renaming them dynamically:
http://stackoverflow.com/questions/467224/renaming-threads-in-java


