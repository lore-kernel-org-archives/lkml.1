Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbZLSAUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbZLSAUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZLSAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:20:05 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:61492 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZLSAUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=OAqjxkTHomOwOgZR6ednEYyxV/Kj5tFf
	Ej6TUDGN0xVBatnu1r+g+DXGaNASoq/UqQjOhyp4eP/KM5fXhiNAQgVF/2j+QcMc
	L/oh12F1AdjNjygw4cS8ULo4Zcwovdc7TidNXWspYQbyeE0LSx2FaATjkMaNU7wb
	9UowW4d10vk=
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suggestion: xtime as new inode attribute
References: <4B292D9A.5060501@poelzi.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Fri, 18 Dec 2009 16:19:53 -0800
In-Reply-To: <4B292D9A.5060501@poelzi.org> (Daniel Poelzleithner's message of
 "Wed\, 16 Dec 2009 19\:57\:30 +0100")
Message-ID: <7vk4wjrf12.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 3D38875C-EC34-11DE-BDFC-DC0DEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Poelzleithner <poelzi@poelzi.org> writes:

> I would like to suggest a new attribute for inodes in linux filesystems
> to record the last execution time of files.
>
> The problem:
>
> If a linux installation gets older and older, more and more programs get
> installed over time. Mostly to just test them for a particular problem
> and often the deinstallation is forgotten. To find out which packages
> are not used for a long time is currently quite impossible. The user may
> use program X which will run but not depend on program Y as a subprocess
> for example.
>
> The solution:
>
> I suggest a new inode attribute called xtime, which is like atime, but
> will only be updated when a file is executed. This would allow tracking
> of unused binaries and could be used with some clever algorithms in the
> cleanup program to find unused packages for removal or other cleanup
> purposes.

As I've never seen "cat /bin/sh" or similar done on an executable binary
by sane people, and I imagine that most sane back-up programs wouldn't
touch atime, I suspect that what you want to do can be done by checking
atime instead.
