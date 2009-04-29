Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZD2TnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZD2TnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZD2TnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:43:13 -0400
Received: from smtp3.netcologne.de ([194.8.194.66]:45291 "EHLO
	smtp3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbZD2TnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:43:11 -0400
Date: Wed, 29 Apr 2009 21:42:55 +0200
From: Max Kellermann <max@duempel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
Message-ID: <20090429194254.GA7956@squirrel.roonstrasse.net>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org
References: <20090429103308.GA23684@squirrel.roonstrasse.net> <87my9zpjqe.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my9zpjqe.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/04/29 17:23, Andi Kleen <andi@firstfloor.org> wrote:
> I don't think splice is about handling all possible cases,
> but just cases where the kernel can do better than user space.
> I don't think that's the case here.

If splice() is about passing pointers of a pipe buffer, what's more
trivial (and natural) than passing that pointer between two pipes?

> > when I read about the splice() system call, I thought it was obvious
> > that it could copy data between two pipes. 
> 
> It would be more efficient if you used fd passing to pass the fd
> around to the other process and let it read directly.

That's not so easy in my case.  The header output of the one process
has to be parsed before the rest of it (or part of the rest) is going
to be forwarded to the second one.  My master process would lose
control over the transfer.  splice() looks like the perfect solution.

Max
