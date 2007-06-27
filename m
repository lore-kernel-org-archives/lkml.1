Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbXF0FEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbXF0FEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXF0FEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:04:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:32775 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXF0FEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X/aCP2ASGJsi9cuq0tNdfW8jIKzenNbgLkpW7qs2JOhtsNQAeU/aVoTeoTSzZhJlPIkdmWze0C485QPdLEWV4v7G3Da+fOsDjIeaIuAmsIoNQkMOemRySLyYuO5XYyfw0NZ+/o4k3uvNJOozzmfa4SjKz2aYvL2jAIn1633sLtI=
Message-ID: <a36005b50706262204s2a6decds70bd56955217de13@mail.gmail.com>
Date: Tue, 26 Jun 2007 22:04:11 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4681E37A.9090708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <4681D45F.7080309@redhat.com>
	 <a36005b50706262045g79c4accak21fea740fdc1bffd@mail.gmail.com>
	 <4681E37A.9090708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Rik van Riel <riel@redhat.com> wrote:
> After going through the first malloc()/free() cycle, surely
> the memory will no longer be zeroed on the second malloc() ?

If returned to the system, sure.


> What makes the first brk malloc so special?

If the memory is zeroed it needs not be initialized by malloc.  No
calloc zeroing, no pointer clearing.

Anyway, it's irrelevant what the benefits are, the fact is current
code depends on brk to zero the memory and you'd break the ABI if
you'd change it.
