Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYILAKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYILAKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 20:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYILAKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 20:10:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYILAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 20:10:03 -0400
Date: Thu, 11 Sep 2008 17:09:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, jdennis@redhat.com, mitr@redhat.com,
       sgrubb@redhat.com
Subject: Re: [PATCH] Audit: fix handling of 'strings' with NULL characters
Message-Id: <20080911170920.e88e7bc5.akpm@linux-foundation.org>
In-Reply-To: <1221169719.2952.14.camel@localhost.localdomain>
References: <1221169719.2952.14.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 17:48:39 -0400
Eric Paris <eparis@redhat.com> wrote:

> currently audit_log_n_untrustedstring() uses
> audit_string_contains_control() to check if the 'string' has any control
> characters.  If the 'string' has an embedded NULL
> audit_string_contains_control() will return that the data has no control
> characters and will then pass the string to audit_log_n_string with the
> total length, not the length up to the first NULL.  audit_log_n_string
> does a memcpy of the entire length and so the actual audit record
> emitted may then contain a NULL and then whatever random memory is after
> the NULL.
> 
> Since we want to log the entire octet stream (if we can't trust the data
> to be a string we can't trust that a NULL isn't actually a part of it)
> we should just consider NULL as a control character.  If the caller is
> certain they want to stop at the first NULL they should be using
> audit_log_untrustedstring.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> ---
> 
> Miloslav, this is also going to take care of nulls in the TTY_AUDIT_USER
> message from userspace.  Is it going to be common to have control
> characters on that code path as well?  Do you want to change
> audit_receive_msg() to also use the hex encoding directly instead of the
> _n_untrustedstring interface?

OK, I am now officially confused about the relationship between this
patch, Miloslav's two patches and 2.6.27/2.6.26/2.6.25.

Think I'll go into hiding for a while - please wake us up when it's all
sorted out.

