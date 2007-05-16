Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbXEPLlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbXEPLlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbXEPLlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:41:25 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:30220 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbXEPLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gHk/vxVa6qg/ohsIOvaiFLKLb+V+czw7Of/RFqiU1cYNJ0dQrUtxyXtd53vWS4qNcVEkqMr+bNARmyr4//u02MST0iW7zaHKat0EUmketSVR0hmTUe5rnyvXatcUg1xehuo43sSiRu74B8oio4B5WzxUOtoe/txW13ttuLFajQ8=
Message-ID: <464AEDD0.3090304@gmail.com>
Date: Wed, 16 May 2007 13:41:04 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Dave Jones <davej@redhat.com>, Francesco Pretto <ceztko@gmail.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com> <200705160129.16048.rob@landley.net>
In-Reply-To: <200705160129.16048.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rob Landley wrote:
> Um, hang on.  So libata can't reliably turn the system off without data loss 
> and potential damage to hardware unless userspace goes through a special song 
> and dance?  And this is _not_ considered a defect in the kernel?

Yeap, definitely a bug in the kernel and we're trying to fix it.  Just
for the record, we have _always_ issued FLUSH CACHE, so there hasn't
been and won't be any data loss problem.  The data loss problem was
mentioned as why we can't do things completely inside kernel without
updating userland shutdown(8) which issues STANDBYNOW.

-- 
tejun
