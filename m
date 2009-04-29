Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZD2J03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZD2J03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZD2J0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:26:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZD2J0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:26:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=H29R1tnGV9h5GDy8i/YlkmHoDwiVELces4edcEumO4jeELpFnk0h/jhUJSuFD75uP
	aEtqiHm8yqA1MjZ5VMj3g==
Date: Wed, 29 Apr 2009 02:26:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <righi.andrea@gmail.com>
cc: akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
 vm_dirty_bytes
In-Reply-To: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
Message-ID: <alpine.DEB.2.00.0904290224260.31490@chino.kir.corp.google.com>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Andrea Righi wrote:

> Avoid to set less than two pages for vm_dirty_byte: this is necessary to avoid
> potential division by 0 (like the following) in get_dirty_limits().
> 

Where exactly is the divide by 0 in get_dirty_limits()?

Is this because we forced the background threshold to be half of the dirty 
threshold when its setting is greater?
