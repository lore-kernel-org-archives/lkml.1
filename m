Return-Path: <linux-kernel-owner+w=401wt.eu-S935358AbYEUNsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935358AbYEUNsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763080AbYEUNrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:47:51 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38648 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761398AbYEUNru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:47:50 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
Date: Wed, 21 May 2008 15:47:45 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz> <200805211533.00221.oliver@neukum.org> <Pine.LNX.4.64.0805211533500.6718@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805211533500.6718@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211547.46399.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 15:36:49 schrieb Jiri Kosina:
> On Wed, 21 May 2008, Oliver Neukum wrote:
> 
> > This turns out not to be the case. Interrupts are disabled.
> 
> You're right, this callchain can't cause the deadlock indeed. I'll go 
> through the other possibilities.

usb_hcd_flush_endpoint() is an obvious case. Used in the suspend code.
Your patch is indeed correct, but I fear there might be a second bug caused
by wrong calling conditions.

	Regards
		Oliver
