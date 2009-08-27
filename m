Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZH0Jok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZH0Jok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZH0Jok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:44:40 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:54844 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZH0Joj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:44:39 -0400
In-Reply-To: <f0e08f230908260815g70de3002pfd0b34f1b17abd6@mail.gmail.com>
References: <200908261337.56128.fenkes@de.ibm.com> <f0e08f230908260815g70de3002pfd0b34f1b17abd6@mail.gmail.com>
To: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, OF-EWG <ewg@lists.openfabrics.org>,
       OF-General <general@lists.openfabrics.org>,
       Hal Rosenstock <hnrose@comcast.net>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [ewg] [PATCH] IB/ehca: Construct MAD redirect replies from 	request MAD
X-KeepSent: F2257478:FF0FEABE-C125761F:00344884;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Build V851_07072009 July 07, 2009
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFF2257478.FF0FEABE-ONC125761F.00344884-C125761F.00358310@de.ibm.com>
Date: Thu, 27 Aug 2009 11:44:30 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.1|February 07, 2008) at
 27/08/2009 11:44:31,
	Serialize complete at 27/08/2009 11:44:31
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hal Rosenstock <hal.rosenstock@gmail.com> wrote on 26.08.2009 17:15:03:

> Thanks for doing this. It looks sane to me. The only issue I recall that 

> appears to be remaining is a better setting of 
ClassPortInfo:RespTimeValue 
> rather than hardcoding. Perhaps using the value from PortInfo is the way 
to go
> (ideally it would be that value from the port to which the the requester 
is 
> being redirected to but that might not be so easy to get from this port.

I don't think that effort will be necessary or even legal. The requestor 
will react to the redirection with another Get(ClassPortInfo) to the 
redirection target, which will reply with its own RespTimeValue, so our 
driver should speak for itself. Since we don't know when our MAD 
processing and sending of the response is going to be scheduled (we're not 
running on real-time constraints here), we play it safe and return 18, 
which amounts to roughly a second. 

Make sense?

Regards
  Joachim
