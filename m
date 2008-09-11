Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYIKTPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYIKTPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYIKTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:15:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568AbYIKTPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:15:20 -0400
Date: Thu, 11 Sep 2008 12:14:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miloslav =?ISO-8859-1?Q?Trma=5F=5F?= <mitr@redhat.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
Message-Id: <20080911121443.c3153842.akpm@linux-foundation.org>
In-Reply-To: <1221085418.2705.19.camel@amilo>
References: <1221085418.2705.19.camel@amilo>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 00:23:38 +0200
Miloslav Trma__ <mitr@redhat.com> wrote:

> audit_string_contains_control() stops checking at the first NUL byte.
> If audit_string_contains_control() returns FALSE,
> audit_log_n_untrustedstring() submits the complete string - including
> the NUL byte and all following bytes, up to the specified maximum length
> - to audit_log_n_string(), which copies the data unchanged into the
> audit record.
> 
> The audit record can thus contain a NUL byte (and some unchecked data
> after that).  Because the user-space audit daemon treats audit records
> as NUL-terminated strings, an untrusted string that is shorter than the
> specified maximum length effectively terminates the audit record.
> 
> This patch modifies audit_log_n_untrustedstring() to only log the data
> before the first NUL byte, if any.

It's unclear how serious this problem is.  Do you believe that it is
sufficiently serious to warrant merging these fixes into 2.6.27? 
2.6.26.x?  2.6.25.x?

Thanks.
