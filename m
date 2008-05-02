Return-Path: <linux-kernel-owner+w=401wt.eu-S1763922AbYEBIbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763922AbYEBIbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYEBIbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:31:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYEBIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:31:35 -0400
Date: Fri, 2 May 2008 10:38:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
Message-ID: <20080502083805.GR20451@one.firstfloor.org>
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com> <20080502072226.GB713@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502072226.GB713@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yep, the image was in a 128 MB chunk from which 88 MB was left empty and 
> modules started at the next 128 MB boundary. The largest image i ever 
> had was around 44MB, so i doubt it's an issue in practice. Mind doing a 
> patch that reinstates it, by lowering the 512 image size limit to 508 
> MB? [4MB should be more than enough in practice]

Actually you could even limit to the exact know size of the kernel (rounded
up to 2MB) after early boot. Then the protection would be even better and less
aliasing to deal with for pageattr.c. Just invalidate the left over PMDs.

-Andi
