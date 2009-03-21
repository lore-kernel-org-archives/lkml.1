Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbZCUFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbZCUFr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZCUFqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:46:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14565 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbZCUFqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=lau9/3IYMoBdrolnX16tofjIFppbmOvo95vV6Gl5/o6btLlR8fxWAjgUbNL5+W63Uu
         uTmSil7NcacZNnmXSUaUIV5P+usH0S2yjpznaEPNXnwZZ8JLLsvk+02JuTlBxOVSMPXn
         xBjhNYXFbzY0nZOo552biSA1AxKy8fp9n9I4A=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Scott James Remnant <scott@canonical.com>
Subject: Re: [PATCH 12/31] input: Auto-load mousedev module when psaux device opened.
Date: Fri, 20 Mar 2009 22:46:44 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-170.2.35.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <cover.1236702228.git.scott@canonical.com> <6c577b415dffe0df86954f2f3971e15a9336d6c6.1236702228.git.scott@canonical.com>
In-Reply-To: <6c577b415dffe0df86954f2f3971e15a9336d6c6.1236702228.git.scott@canonical.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200903202246.44458.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

On Tuesday 03 March 2009 07:32:15 Scott James Remnant wrote:
> The mousedev module is missing the char-major-10-1 alias that would cause
> it to be auto-loaded when the /dev/psaux device is opened.  This patch
> adds the alias.
>

I think we are trying to go in the different direction that what you are
proposing - we should automatically load mousedev and other input handlers
when input device that is compatible with that handler is registered with
input core, not the other way around. This way you won't need static device
node in your /dev, udev will create it for you as needed.

Same goes for your other patch.

-- 
Dmitry

