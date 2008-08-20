Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYHTWhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYHTWhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYHTWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:37:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:49702 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYHTWh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:37:27 -0400
Date: Thu, 21 Aug 2008 08:37:08 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Further fix execve error handling
In-Reply-To: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808210833080.8202@tundra.namei.org>
References: <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, David Howells wrote:

> Further fix [compat_]do_execve() error handling.  free_bprm() will release the
> cred_exec_mutex, but only if bprm->cred is not NULL.

This seems quite ugly and error-prone, with a mutex_unlock() being called 
from a helper function rather than the body of the function which locked 
it.

How about moving the mutex_unlock() out of free_bprm() and into the 
calling code ?


- James
-- 
James Morris
<jmorris@namei.org>
