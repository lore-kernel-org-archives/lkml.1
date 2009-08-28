Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZH1M7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZH1M7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZH1M67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:58:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:55395 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZH1M67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:58:59 -0400
In-Reply-To: <f0e08f230908270631j3e159f3fgb0034eb41acdac7b@mail.gmail.com>
References: <200908261337.56128.fenkes@de.ibm.com>	 <f0e08f230908260815g70de3002pfd0b34f1b17abd6@mail.gmail.com>
	 <OFF2257478.FF0FEABE-ONC125761F.00344884-C125761F.00358310@de.ibm.com> <f0e08f230908270631j3e159f3fgb0034eb41acdac7b@mail.gmail.com>
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
X-KeepSent: A25F14CC:CE7042E9-C1257620:00453C46;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Build V851_07072009 July 07, 2009
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFA25F14CC.CE7042E9-ONC1257620.00453C46-C1257620.00474D70@de.ibm.com>
Date: Fri, 28 Aug 2009 14:58:49 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.1|February 07, 2008) at
 28/08/2009 14:58:51,
	Serialize complete at 28/08/2009 14:58:51
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hal Rosenstock <hal.rosenstock@gmail.com> wrote on 27.08.2009 15:31:40:

> I don't think it should be hard coded. IMO it would be better to default 
to 18
> and somehow able to be adjusted (via a (dynamic) module parameter ?).

I don't see how making this a parameter would benefit any end user, while 
on the other hand it clutters up our parameter list.

Changing RespTimeValue won't influence the IB performance or user-visible 
behavior of our driver in any way, and in fact, all RespTimeValue says is 
"Please use a timeout of one second for all future MADs you send me", only 
there won't be any more MADs in the future because we just redirected the 
client to someone else. So, the RespTimeValue field is a don't care in the 
redirection scenario. Setting it to an arbitrary, but legal value isn't 
much more than a concession towards any broken clients that may be out 
there.

Given that you seem to like the rest of the code and Jason hasn't spoken 
up yet, I think we can have Roland merge this patch. Roland, what do you 
think?

Regards,
  Joachim

