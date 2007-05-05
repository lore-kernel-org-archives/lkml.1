Return-Path: <linux-kernel-owner+w=401wt.eu-S1031759AbXEEPbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031759AbXEEPbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031760AbXEEPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:31:09 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:51067 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031758AbXEEPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tsLb5oAB7bD80rK0zAiqy8xD1cFBeZMVeJb4BAO4GbLTz+Z6GxRaTlyIlp4dCVw7x8uFpb5xgIApU66QOy6N2Af8pseqBS5Y74C9kOCtxYn5hJ3HUWSzWUsm32qxu9FvAduhuYn13x0V2IEXIDTlsN7XuRhYwKAbfF4WQhGDyOk=
Message-ID: <463CA32B.1010505@gmail.com>
Date: Sat, 05 May 2007 17:30:51 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: jirislaby@gmail.com, akpm@osdl.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: 2.6.21-mm1: many processes end up in D state
References: <200705041919.l44JJ15g009202@harpo.it.uu.se>
In-Reply-To: <200705041919.l44JJ15g009202@harpo.it.uu.se>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
>> I.e. no freezing of ports...
> 
> Your patch to delete the 'return 1;' on error is correct,
> and makes the code match exactly the behaviour of previous
> versions of sata_promise, except for the additional error
> decoding.
> 
> ahci and sata_sil24 do the return in this situation. I don't
> yet understand why they can get away with it while sata_promise
> cannot, but for now the return should be removed.

That's because sata_sil24 and ahci call either ata_port_abort() or
ata_port_freeze() prior to finishing error_intr routine.  Both functions
abort all in-flight command and schedule EH.

--
tejun

