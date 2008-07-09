Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYGIS0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYGIS0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYGIS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:26:25 -0400
Received: from gw.goop.org ([64.81.55.164]:40430 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYGIS0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:26:24 -0400
Message-ID: <487502BD.2020206@goop.org>
Date: Wed, 09 Jul 2008 11:26:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org>
In-Reply-To: <4874FFC4.7050505@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> That is going to be difficult. The GS register is tied up for the pda area
> as long as you have it. And you cannot get rid of the pda because of the library
> compatibility issues. We would break binary compatibility if we would get rid of the pda.
>
> If one attempts to remove one field after another then the converted accesses will not be able to use GS relative accesses anymore. This can lead to all sorts of complications.
>   

Eh?  Yes they will.  That's the whole point of making the pda a percpu 
variable itself.  You can use %gs:<small> to get to the pda, and 
%gs:<larger> to get to percpu variables.  Converting pda->percpu will 
just have the effect of increasing the %gs offset into the percpu space.

This project isn't interesting to me unless per-cpu variables are 
directly accessible off %gs.

    J
