Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYJZQMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYJZQMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 12:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYJZQLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 12:11:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3464 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753964AbYJZQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 12:11:53 -0400
Date: Sun, 26 Oct 2008 12:11:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.27.3 usbcore] Move __module_param_call(nousb) to
 immediately after declaration of nousb.
In-Reply-To: <200810251010.CHE87503.tSJMOOQVLFFOFH@I-love.SAKURA.ne.jp>
Message-ID: <Pine.LNX.4.44L0.0810251126390.4073-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Tetsuo Handa wrote:

> Hello.
> 
> I tried on Fedora 9 (gcc (GCC) 4.3.0 20080428 (Red Hat 4.3.0-8)),
> and I got the same result.
> 
> Just applying http://lkml.org/lkml/diff/2008/10/24/240/1 :

You've got a possible problem here:

> +static int param6;
> +module_param_named(paramtest, param6, int, 0644);
> +MODULE_PARM_DESC(paramtest, "param6");

You used paramtest as both the name of the module and the name of 
the parameter.  I don't know if that would cause the error you're 
seeing, though.  You might want to try again using a different name, 
like param6test.

Alan Stern

