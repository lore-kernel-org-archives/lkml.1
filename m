Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYAOVsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYAOVsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYAOVs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:48:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:22678 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYAOVs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qTWae97R374IidJ40fLveXmApXY/KCbROY93b3dte06ghtsimSzs64YEbgOEhjXYRelLMXUsJJiyIhF2ICdo1TrIVCcZhQ+jQm00MYJlEKBb6RwRfYx5HFHTTuoaola+exrlodhGc6UfT1I15JBaapuVExBNh85SXrm6xD9IVuc=
Date: Tue, 15 Jan 2008 16:48:18 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: dtor@mail.ru, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] input: psmouse: fix potential input register race in
	psmouse_connect()
Message-ID: <20080115164731.ZZRA012@mailhub.coreip.homeip.net>
References: <20080112151345.5d14c104@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112151345.5d14c104@ephemeral>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 03:13:45PM -0500, Andres Salomon wrote:
> 
> If we successfully call input_register_device() in
> psmouse_connect but sysfs_create_group() fails, we'll enter the error
> path without ever having called input_unregister_device() (potentially
> leaking memory, or creating a race condition if something else attempts
> to access the new input device).  This calls input_unregister_device
> from the error path, and sets input_dev to NULL so that we don't
> attempt to also call input_free_device on it.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Applied, thank you Andres.

-- 
Dmitry

