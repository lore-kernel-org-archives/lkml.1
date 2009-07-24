Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZGXSoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZGXSoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZGXSoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:44:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55469 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZGXSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:44:08 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Trevor Pace <tr212206@dal.ca>
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
Date: Fri, 24 Jul 2009 18:53:17 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
In-Reply-To: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907241853.17877.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 24. Juli 2009 17:48:03 schrieb Trevor Pace:
> Removed useless return value variables.
>
> Signed-off By: Trevor Pace <trevor.pace@dal.ca>

These changes are a bad idea. They'll bite us in the ass as soon as we
change locking or need to do more cleanups. The preferred form of
error handling is

r = op()
if (r < 0)
	goto error_exit;

I suggest that you don't apply them.

	Regards
		Oliver

