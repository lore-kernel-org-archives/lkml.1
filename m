Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYDITUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYDITUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbYDITUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:20:13 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:21806 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754789AbYDITUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:20:11 -0400
X-YMail-OSG: 5gFLY1cVM1ne_SuYLhOWH9JOUr.4.KoE17F3yq0SbQwCIHZzFhwTsz0AH6syXHc0tKw2oL19Rq0bA2W6Y3enZND4FMweTBn5gDeYZkWg0IVMPtZwNpEAkFxm5xpiZhJoGfRClUQfgXflCQ--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 9 Apr 2008 14:16:34 -0500
From: serge@hallyn.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: sukadev@us.ibm.com, linux-kernel@vger.kernel.org,
       Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, serue@us.ibm.com, clg@fr.ibm.com
Subject: Re: [RFC][PATCH 0/7] Clone PTS namespace
Message-ID: <20080409191634.GA25220@vino.hallyn.com>
References: <20080408215333.GA8799@us.ibm.com> <47FC138B.4070408@zytor.com> <20080409162353.GA14044@us.ibm.com> <47FD046C.6070804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FD046C.6070804@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting H. Peter Anvin (hpa@zytor.com):
> sukadev@us.ibm.com wrote:
>> We want to provide isolation between containers, meaning PTYs in container
>> C1 should not be accessible to processes in C2 (unless C2 is an ancestor).
>
> Yes, I certainly can understand the desire for isolation.  That wasn't what 
> my question was about.
>
>> The other reason for this in the longer term is for checkpoint/restart.
>> When restarting an application we want to make sure that the PTY indices
>> it was using is available and isolated.
>
> OK, this would be the motivation for index isolation.
>
>> A complete device-namespace could solve this, but IIUC, is being planned
>> in the longer term. We are hoping this would provide the isolation in the
>> near-term without being too intrusive or impeding the implementation of
>> the device namespace.
>
> I'm just worried about the accumulation of what feels like ad hoc 
> namespaces, causing a very large combination matrix, a lot of which don't 
> make sense.

Hmm, if we were to just call this CLONE_NEWDEV, would that (a) make
sense and (b) suitably address your (certainly valid) concern?

Basically for now CLONE_NEWDEV wouldn't yet be fully implemented, only
unsharing unix98 ptys...

-serge
