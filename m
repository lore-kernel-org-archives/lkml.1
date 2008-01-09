Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYAIKAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYAIKAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYAIKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:00:31 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:60436 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYAIKAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:00:30 -0500
From: Junio C Hamano <junio@pobox.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org>
	<20080108185255.GA4627@martell.zuzino.mipt.ru>
	<20080108191843.GA1004@one.firstfloor.org>
	<200801090140.58864.arnd@arndb.de>
	<20080109004748.GI2117@one.firstfloor.org>
cc: Arnd Bergmann <arnd@arndb.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Date: Wed, 09 Jan 2008 02:00:21 -0800
In-Reply-To: <20080109004748.GI2117@one.firstfloor.org> (Andi Kleen's message
	of "Wed, 9 Jan 2008 01:47:48 +0100")
Message-ID: <7vir23jp3e.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> I imagined it would check for 
>
> +struct file_operations ... = { 
> +      ...
> +	.ioctl = ...
>
> That wouldn't catch the case of someone adding only .ioctl to an 
> already existing file_operations which is not visible in the patch context, 
> but that should be hopefully rare. The more common case is adding
> completely new operations.

Because "diff -p" format used by the kernel mailing list takes
the most recent line that begins with an identifier letter and
put that on the hunk header line, even in such a case, you will
see:

	@@ -l,k +m,n @@ struct file_operations ... = {
		...
		...
	+	...
	+	.ioctl = ...
	+	...
		...

which would be a good enough cue that the new .ioctl member is
added to file_operations.
