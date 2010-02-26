Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab0BZU2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:28:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35845 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965955Ab0BZU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:28:47 -0500
Date: Fri, 26 Feb 2010 15:28:22 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 1/2] umh && creds: convert
 call_usermodehelper_keys() to use subprocess_info->init()
Message-ID: <20100226202822.GC31078@hmsreliant.think-freely.org>
References: <20100226182325.GA31674@redhat.com>
 <20100225181500.GA18008@redhat.com>
 <16951.1267207238@redhat.com>
 <17603.1267209668@redhat.com>
 <20100226200313.GA16092@redhat.com>
 <20100226200357.GB16092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226200357.GB16092@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 09:03:57PM +0100, Oleg Nesterov wrote:
> call_usermodehelper_keys() uses call_usermodehelper_setkeys() to change
> subprocess_info->cred in advance. Now that we have info->init() we can
> change this code to set tgcred->session_keyring in context of execing
> kernel thread.
> 
> Note: since currently call_usermodehelper_keys() is never called with
> UMH_NO_WAIT, call_usermodehelper_keys()->key_get() and umh_keys_cleanup()
> are not really needed, we could rely on install_session_keyring_to_cred()
> which does key_get() on success.
> 
> Compile tested.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

