Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZJ0ASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZJ0ASn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZJ0ASm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:18:42 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:39130 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZJ0ASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=Da6EfboV6UhKQahDGrhPzNKndW0D7zHc
	pbXL+6v8oN2XSF04c/sBxQxs6P4Qxkq34k0HqCO9T70Htfs8Chf6BgpXjLI12vJW
	WdstD51b7O5jfBT5DXuLZE+l1T5w4V7NF2UngfkX2S3xmycci0++9YaDg87ZlcOU
	bGleXUiGwJ0=
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, git <git@vger.kernel.org>,
       mercurial@selenic.com, Marti Raudsepp <marti@juffo.org>
Subject: Re: git vs hg commit counts?
References: <1256602127.29938.8.camel@Joe-Laptop.home>
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 26 Oct 2009 17:18:33 -0700
In-Reply-To: <1256602127.29938.8.camel@Joe-Laptop.home> (Joe Perches's
 message of "Mon\, 26 Oct 2009 17\:08\:47 -0700")
Message-ID: <7v8wexd6zq.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 478F9C56-C28E-11DE-9D37-1B12EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> I'm comparing linux-kernel git vs hg repositories.
>
> While testing some changes to scripts/get_maintainer.pl,
> I noticed that git and hg have different commit counts
> for the same files.
>
> For instance:
>
> $ git log --since=1-year-ago -- MAINTAINERS | \
> 	grep -P "^commit [0-9a-f]{40,40}$"  | wc -l
> 514
>
> $ hg log --template="commit {node}\n" --date -365 -- MAINTAINERS  | \
> 	grep -P "^commit [0-9a-f]{40,40}$" | wc -l
> 601
>
> Anyone have any understanding why?

We simplify a merge history by discarding one branch when the merge result
matches one of the parents.  Does "hg" know how to do that as well?

