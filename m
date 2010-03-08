Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0CHKdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:33:10 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62000 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0CHKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=H6QROzS3wTb5hhlyvLcvokKof/S5vHdLUHbA4+tFvHvHwnFpSRjM+ZKEJfiz3gXSXl
         T7PbKG+EWLOZtu2mBVi3URJ+s2fnvotxz9W7E0VcdQbm+3u9OHJ+vivFpO134G6OXagz
         4T6MErbPjlbMMdYsEyr+P4+r2N7JBb+1E9CBk=
MIME-Version: 1.0
In-Reply-To: <20100305174203.GA19638@sgi.com>
References: <20100305174203.GA19638@sgi.com>
Date: Mon, 8 Mar 2010 11:33:04 +0100
Message-ID: <b647ffbd1003080233y5f06797fucaca3cf839e4de57@mail.gmail.com>
Subject: Re: [PATCH] x86: Intel microcode loader performance improvement
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2010 18:42, Dimitri Sivanich <sivanich@sgi.com> wrote:
> We've noticed that on large SGI UV system configurations, running
> microcode.ctl can take very long periods of time.  This is due to
> the large number of vmalloc/vfree calls made by the Intel
> generic_load_microcode() logic.
>
> By reusing allocated space, the following patch reduces the time
> to run microcode.ctl on a 1024 cpu system from approximately 80
> seconds down to 1 or 2 seconds.
>
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

This approach seems reasonable in the scope of the current framework.

Acked-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

However, I think a better approach would be to have some kind of
shared storage for loaded microcode updates. Given that for the
majority of SMP systems all the cpus are normally updated to the very
same new instance of microcode, it should be enough to do a search for
the first cpu, cache the instance of microcode and then reuse it for
others.


-- Dmitry
